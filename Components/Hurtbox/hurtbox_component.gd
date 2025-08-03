extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func damage(damage_amount : float) -> void:
	if not health_component : return
	
	health_component.current_health -= damage_amount
