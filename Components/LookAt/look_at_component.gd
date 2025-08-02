extends Node
class_name LookAtComponent

@export var range_component : RangeComponent
@export var rotate_weight : float = 2

@onready var parent : Node2D = get_parent()

func _physics_process(_delta : float) -> void:
	look(_delta)

func look(d : float) -> void:
	if range_component.entities.size() <= 0: return
	
	var end_rotation : float = parent.global_position.direction_to(range_component.entities[0].global_position).angle()
	parent.global_rotation = move_toward(parent.global_rotation, end_rotation, rotate_weight * d)
