extends Node
class_name ProjectileComponent

@onready var character : CharacterBody2D = get_parent()

func _physics_process(_delta : float) -> void:
	character.move_and_slide()

func projectile_delete() -> void:
	character.queue_free()
