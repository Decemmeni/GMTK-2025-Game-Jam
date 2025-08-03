extends Node
class_name HealthComponent

@export var max_health : float = 50.0

var current_health : float : set = _set_health

signal damaged
signal died
signal healed

func _ready() -> void:
	current_health = max_health

func _set_health(new_hp : float) -> void:
	if new_hp < 0:
		died.emit()
	elif new_hp < current_health:
		damaged.emit()
	elif new_hp > current_health:
		healed.emit()
	current_health = new_hp
	
	
