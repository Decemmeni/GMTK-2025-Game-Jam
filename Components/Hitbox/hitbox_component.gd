extends Area2D
class_name HitboxComponent

# Don't forget to set collision mask, no collision_layer
@export var damage : float = 5.0

signal hurt_something

func _on_area_entered(area: Area2D) -> void:
	if not area is HurtboxComponent: return
	
	var a : HurtboxComponent = area
	hurt_something.emit()
	a.damage(damage)
