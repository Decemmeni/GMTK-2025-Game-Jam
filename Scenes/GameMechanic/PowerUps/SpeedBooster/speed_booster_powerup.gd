extends Node2D
class_name SpeedBoosterPowerup

@onready var power_up_component: PowerUpComponent = $PowerUpComponent
@onready var player : Player = get_parent()

func _ready() -> void:
	player.extra_rotation_speed += 1.5

func end() -> void:
	player.extra_rotation_speed -= 1.5
	power_up_component.used()
