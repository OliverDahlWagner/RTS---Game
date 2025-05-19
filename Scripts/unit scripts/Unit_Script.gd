extends CharacterBody2D

class_name Unit
var unit_max_health: int
@export var unit_health: int = 100     #base
@export var unit_base_attack: int = 50 #base

var target = null
var targets: Array = []

@export var attack_timer:float = 0.0
var attack_on_cooldown:float = 0.0

@onready var unit_ani_sprite = $Unit_Ani_Sprite
@onready var unit_highlight = $Unit_Highlight
@onready var unit_movement_collision = $Unit_movement_collision
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var hit_range = $Hit_Range
@onready var unit_healthbar = $Unit_Healthbar


var unit_movement = load("res://Scripts/unit scripts/Unit_movement.gd")
#var enemy_movement = load("res://Scripts/unit scripts/Unit_Enemy_Movement.gd")
var movement_instance = null

# make custom init when time comes

func _ready():
	unit_setup()

func _physics_process(delta):
	movement_instance.npc_movement(self.global_position, navigation_agent_2d, velocity, unit_ani_sprite, self)
	handle_sprites()

func unit_setup():
	movement_instance = unit_movement.new()
	movement_instance.initialize(self, navigation_agent_2d)
	unit_max_health = unit_health

func handle_sprites():
	if unit_health <= 0:
		unit_ani_sprite.play("Death")
		await unit_ani_sprite.animation_finished
		queue_free()
	
	if targets.size() == 0 and velocity == Vector2.ZERO:
		unit_ani_sprite.play("Idle")
	
	if velocity != Vector2.ZERO:
		if targets.size() != 0:
			pass
		else:
			unit_ani_sprite.play("Walk")


func set_highlight():
	if unit_highlight.visible:
		unit_highlight.visible = false
	else:
		unit_highlight.visible = true
	
	if unit_healthbar.visible:
		unit_healthbar.visible = false
	else:
		unit_healthbar.visible = true

func set_movement_destination(position):
	
	movement_instance.target_position = position # used to matter, still kinda the if
	navigation_agent_2d.target_position = position 

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func _on_hit_range_target_list_updated(updated_targets):
	targets = updated_targets


func take_damage(damage:int):
	#print("hit hit")
	unit_health -= damage
	unit_healthbar.update_healthbar_value(unit_health)


func set_target(list_of_targets) -> Node2D:
	
	return list_of_targets[0]

func attack(damage: int):   # dont walk in and out of attack range, doesnt crash, but doesnt quite wotj RIGHT, still works
	target = set_target(targets)
	
	# target gaurd
	if target == null:
		#print("No valid target to attack.")
		return
	if target.unit_health <= 0:
		#print("Target is dead, skip attack or crash.")
		return
	
	unit_ani_sprite.play("Attack")
	await unit_ani_sprite.animation_finished
	if targets.has(target):
		target.take_damage(damage)
		if target.unit_health <= 0:
			target = null
	
	attack_on_cooldown = attack_timer

func _on_attack_swing_timer_timeout():
	if targets.size() != 0 and unit_health > 0:
		attack(unit_base_attack)
