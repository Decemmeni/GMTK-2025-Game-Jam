extends Node2D
class_name Bubble

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var line: Line2D = $Line
var completed : bool = false
var current_completion : float = 0

signal completed_bubble

func _physics_process(_delta: float) -> void:
	complete()

func complete() -> void:
	if completed: return
	
	if abs(current_completion) > 2*PI:
		completed_bubble.emit()
		completed = true
