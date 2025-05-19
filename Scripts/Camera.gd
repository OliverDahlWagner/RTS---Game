extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	cam_zoom(event)
	cam_follow_drag(event)

func cam_zoom(event: InputEvent):
	if event is InputEventMouseButton and event.is_action("zoom") and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= Vector2(1.1,1.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= Vector2(0.9,0.9)

const DRAG_THRSHOLD = 55
var dragging = false
var drag_start = Vector2()
var thing = Vector2()

signal click_event(drag_start_position)

func cam_drag(event: InputEvent):
	if event is InputEventMouseButton and InputEventMouseMotion and event.is_action("right_click"):
		if event.is_pressed():
			dragging = true
			drag_start = to_local(get_global_mouse_position()) 
			thing = get_global_mouse_position()
		else:
			dragging = false
			var drag_end = to_local(get_global_mouse_position())
			
			if drag_start.distance_to(drag_end) < DRAG_THRSHOLD:
				click_event.emit(thing)


func cam_follow_drag(event: InputEvent):
	cam_drag(event)
	if event is InputEventMouseMotion and dragging:
		global_position -= event.relative / zoom
