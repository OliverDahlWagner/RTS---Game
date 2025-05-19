extends Area2D

@export var targets_in_range: Array = []
@export var enemy_in_range: Array = []  # maybe for later
@export var friend_in_range: Array = []   # maybe for later

signal target_list_updated(updated_targets: Array)

func _on_body_entered(body):
	
	if body == self or body == get_parent():
		return
	
	if get_parent().is_in_group("Player_Unit"):
		if body.is_in_group("Enemy_Unit"):
			targets_in_range.append(body)
	
	if get_parent().is_in_group("Enemy_Unit"):
		if body.is_in_group("Player_Unit"):
			targets_in_range.append(body)
	
	emit_signal("target_list_updated", targets_in_range)

func _on_body_exited(body):
	if body in targets_in_range:
		targets_in_range.erase(body)
		emit_signal("target_list_updated", targets_in_range)


#func _on_hit_range_body_entered(body):
	#if body == unit:
		#return
	#
	#if body.is_in_group("Enemy_Unit") and unit.is_in_group("Player_Unit") or body.is_in_group("Player_Unit") and unit.is_in_group("Enemy_Unit"):
		#targets_in_range.append(body)
		#if target == null:
			#target = body
		#print(unit.name, " is attacking")
#
#func _on_hit_range_body_exited(body):
	#if body == unit:
		#return
	#
	#if body in targets_in_range:
		#targets_in_range.erase(body)
	#
	#if body == target:
		#if targets_in_range.size() > 0:
			#target = targets_in_range[0]
		#else:
			#target = null
			#unit_animation.play("Idle")
