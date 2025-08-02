extends Node
class_name PowerUpComponent

@onready var parent : Node2D = get_parent()

func used() -> void:
	parent.queue_free()
