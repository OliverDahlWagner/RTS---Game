#extends RefCounted
#class_name Unit
extends Node

@onready var unit = $".."
@onready var health_label = $"../Label"

@onready var unit_animation = $"../AnimatedSprite2D"

@export var max_health = 100
@export var base_attack = 15

@export var unit_health:int
@export var unit_attack:int
@export var attack_timer:float = 0.0
var attack_on_cooldown:float = 0.0

var targets_in_range = []
var target

func _ready():
	unit_health = max_health
	unit_attack = base_attack
	health_label.text = str(unit_health)

func _process(delta: float):
	health_label.text = str(unit_health)

func set_health(health: int):
	unit_health = health

func take_damage(damage:int):
	unit_health -= damage
	if unit_health <= 0:
		print("Unit has died")

#func attack(target: Node, damage: int):
	#target.unit_data.take_damage(damage)
	#target.unit_data.unit_animation.play("Attack")
	#await target.unit_data.unit_animation.animation_finished
	#if target.unit_data.unit_health <= 0:
		#target.unit_data.unit_animation.play("Death")
		#await target.unit_data.unit_animation.animation_finished
		#target.queue_free()
		#target = null
	#attack_on_cooldown = attack_timer
#
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
#
#func _on_timer_timeout():
	#if target != null:
		#attack(target, unit_attack)


func target_list_updated(updated_targets):
	print("fisufg")
