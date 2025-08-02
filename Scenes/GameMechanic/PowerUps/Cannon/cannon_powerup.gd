extends Node2D
class_name CannonPowerup

@onready var power_up_component: PowerUpComponent = $PowerUpComponent

func end() -> void:
	power_up_component.used()
