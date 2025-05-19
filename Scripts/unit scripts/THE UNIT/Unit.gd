extends Node

class_name Unit_test

var unit_health
var unit_base_attack

var targets: Array = []

func _init(health, attack):
	unit_health = health
	unit_base_attack = attack

func set_targets(target_list):
	targets = target_list

func take_damage(damage:int):
	unit_health -= damage
	if unit_health <= 0:
		print("Unit has died")

func attack(target: Node, damage: int):
	print("bang bang")

func tester():
	print("okok")

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


func default_target():
	print(targets[0])

func high_health_target():
	print(targets[0])

func low_health_target():
	print(targets[0])
