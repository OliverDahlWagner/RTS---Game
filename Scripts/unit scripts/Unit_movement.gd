extends Node2D

var SPEED = 100.0
var target_position = null

func initialize(parent, navi_agent_2d):
	if parent.is_in_group("Enemy_Unit"):
		if target_position == null:
			var nodes = parent.get_tree().get_nodes_in_group("Castle")
			if nodes.size() > 0:
				var target = nodes[0]  # Assuming there's only one node in that group
				#print(target.get_position())
				target_position = target.get_position()
				navi_agent_2d.target_position = target.get_position()

# ok now the enemies are walking the to castle, make some behavior would be nice
### Horde behavoir might be for later
### Better group movement
### Stop Enemy movement when attacking

func npc_movement(unit_position, navi_agent, velocity, unit_ani_sprite, parent):
	if target_position:
		var current_agent_position = unit_position
		var next_path_position = navi_agent.get_next_path_position()
		var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED
		
		navi_agent.velocity = new_velocity
		
		if velocity.x > 0:
			unit_ani_sprite.flip_h = false
		else:
			unit_ani_sprite.flip_h = true
		
		if navi_agent.is_navigation_finished():
			return
		
		navi_agent.set_velocity_forced(new_velocity)
		
		#if navi_agent.avoidance_enabled:
			#navi_agent.set_velocity_forced(new_velocity)
		#else:
			#pass
			#parent._on_navigation_agent_2d_velocity_computed(new_velocity)
			
		parent.move_and_slide()
