extends TextureProgressBar

func _ready():
	call_deferred("initialize_health")

func initialize_health():
	min_value = 0
	max_value = get_parent().unit_max_health
	value = get_parent().unit_health

func update_healthbar_value(current_health):
	value = current_health
