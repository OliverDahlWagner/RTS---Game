extends Node2D

var dragging = false  
var selected = []  
var drag_start = Vector2.ZERO  
var select_rect = RectangleShape2D.new() 

var fill_color = Color(0, 1, 0, 0.2)     # Semi-transparent green 
var border_color = Color(0, 1, 0, 1)       # Solid green edge

func _ready():
	pass

func _process(_delta):
	
	pass

func _input(event):
	select_drag(event)

const DRAG_THRSHOLD = 40

func select_drag(event: InputEvent):
	if event.is_action("select"):
		if event.is_pressed():
			#de_select_highlight()
			dragging = true
			drag_start = to_local(get_global_mouse_position())
		else:
			dragging = false
			# absolutte mouseposition
			var drag_end = to_local(get_global_mouse_position())   
				
			if drag_start.distance_to(drag_end) < DRAG_THRSHOLD:
				selected = selection(select_rect, selected, drag_start, drag_end, true)
				#select_highlight()
				# should be single select and ui interacting
				
			else:
				queue_redraw()
				select_rect.extents = abs(drag_end - drag_start) / 2  
				selected = selection(select_rect, selected, drag_start, drag_end, false)
				#select_highlight()
	
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func selection(shape:  RectangleShape2D, unit_array, start_pos, end_pos, single) -> Array:
	
	if unit_array.size() != 0:
		for item in unit_array:
		  # now unit is the top-level Node2D unit
			if not is_instance_valid(item):
				continue  # unit died/deleted, skip it or crash
			if item.has_method("set_highlight"):
				item.set_highlight()
	
	if single:
		var click_rect = RectangleShape2D.new()
		click_rect.extents = Vector2(2,2)
		var space = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = click_rect
		query.collision_mask = 2
		query.transform = Transform2D(0, start_pos)
		var collisions = space.intersect_shape(query)
		print("Collisions found: ", collisions.size())
		for item in collisions:
			var collider = item["collider"]
			print("Collider detected: ", collider.name, "of type: ", collider.get_class())
		unit_array = collisions
	else:
		shape.extents = abs(end_pos - start_pos) / 2  
		var space = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = select_rect
		query.collision_mask = 2
		query.transform = Transform2D(0, (end_pos + start_pos) / 2)  
		var collisions = space.intersect_shape(query)
		print("Collisions found: ", collisions.size())
		for item in collisions:
			var collider = item["collider"]
			print("Collider detected: ", collider.name, "of type: ", collider.get_class())
		unit_array = collisions
	queue_redraw() # this might help with with the missprint issue
	
	var node2d_units = []
	for item in unit_array:
		var collider = item["collider"]
		# Go up to Node2D.
		if collider.is_in_group("Player_Unit"):
			if collider.has_method("set_highlight"):
				collider.set_highlight()
			node2d_units.append(collider)
		else:
			print("Unit not in group 'Player_Unit': ", collider.name)
	
	print(node2d_units)
	
	return node2d_units

func _draw():
	if dragging:
		var rect = get_drag_rect()   
		draw_rect(rect, fill_color, true)  
		draw_rect(rect, border_color, false, 4.0)  

# Helperfunction, for drawing rects
func get_drag_rect() -> Rect2:
	var current_position = to_local(get_global_mouse_position())
	var x = min(drag_start.x, current_position.x)
	var y = min(drag_start.y, current_position.y)
	var width = abs(drag_start.x - current_position.x)
	var height = abs(drag_start.y - current_position.y)
	return Rect2(x, y, width, height)

func _on_click_event(drag_start_position):
	command(drag_start_position) 

func command(position):
	if selected.size() == 0:
		return
	
	var units = []
	for result in selected:
		if not is_instance_valid(result):
			continue # unit died/deleted, skip it or crash
		units.append(result)
	
	move_selected_units(position, units)

func move_selected_units(position, units) -> void:
	var positions = generate_positions(position, units.size(), 20)
	
	for i in range(units.size()):	
		var unit = units[i]
		var pos = positions[i]
		if unit.has_method("set_movement_destination"):
			unit.set_movement_destination(to_local(pos))

func generate_positions(start: Vector2, count: int, radius: float) -> Array:
	var positions = []
	positions.append(to_local(start))

	if count <= 1:
		return positions

	var angle_step = 360.0 / (count - 1)
	
	# this needs to be better to handle larger amounts. for later
	for i in range(count - 1):
		var angle_deg = angle_step * i
		var angle_rad = deg_to_rad(angle_deg)
		var offset = Vector2(cos(angle_rad), sin(angle_rad)) * radius
		positions.append(start + offset)
	return positions


func set_select_highlight(status: bool):
	for result in selected:
		var unit = result["collider"]
		unit.set_highlight(status)
