extends Node2D
class_name Bubble

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var replace_ink: Sprite2D = $ReplaceInk
var completed : bool = false
var current_completion : float = 0
var start_pos : float = 0
var max_left : float = 0
var max_right : float = 0

signal completed_bubble

func _physics_process(_delta: float) -> void:
	complete()
	update_outline()

func complete() -> void:
	if completed: return
	
	#if abs(current_completion) > 2*PI:
	if abs(max_left - start_pos) + abs(max_right - start_pos) >= 360:
		completed_bubble.emit()
		completed = true

func update_outline() -> void:
	if completed: 
		replace_ink.material.set("shader_parameter/start_deg", 0.001)
		replace_ink.material.set("shader_parameter/end_deg", 0)
		return
	
	replace_ink.material.set("shader_parameter/start_deg", max_right)
	replace_ink.material.set("shader_parameter/end_deg", max_left)
