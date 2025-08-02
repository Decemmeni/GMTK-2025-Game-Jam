extends Node2D
class_name ShieldPowerup

@export var max_hits : int = 3

@onready var power_up_component: PowerUpComponent = $PowerUpComponent

var current_hits : int

func _ready() -> void:
	current_hits = max_hits


func _on_shield_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	current_hits -= 1
	if current_hits <= 0: power_up_component.used()
