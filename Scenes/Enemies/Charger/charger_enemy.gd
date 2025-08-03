extends CharacterBody2D
class_name ChargerEnemy

@export var starting_radian : float = 0.0
@export var spin_speed : float = -PI/128

@onready var bubble : Bubble = get_parent()
var current_radian : float = 0.0


func _ready() -> void:
	if spin_speed < 0: 
		scale.x = -1
		scale.y = -1
	else:
		scale.x = 1
		scale.y = 1
	
	bubble.completed_bubble.connect(die)
			  
func _physics_process(_delta: float) -> void:
	spinny_spin()                                     

func spinny_spin() -> void:
	if not bubble or not bubble.collision_shape_2d: return
	
	current_radian += spin_speed
	
	var r : float = bubble.collision_shape_2d.shape.radius
	global_position = bubble.global_position + Vector2(cos(current_radian + starting_radian), sin(current_radian + starting_radian)) * r
	global_rotation = Vector2(cos(current_radian + starting_radian), sin(current_radian + starting_radian)).angle() + PI/2

func die() -> void:
	$AnimationPlayer.play("die")
