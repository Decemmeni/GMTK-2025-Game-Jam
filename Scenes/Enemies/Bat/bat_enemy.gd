extends CharacterBody2D
class_name BatEnemy

@export var bat_speed : float = 200.0
@export var acceleration : float = 40.0

@onready var bubble : Bubble = get_parent()

var dead : bool = false
var wander_point: Vector2 

func _ready() -> void:
	bubble.completed_bubble.connect(die)

func _physics_process(_delta : float) -> void:
	wander(_delta)
	chase(_delta)
	move_and_slide()

func wander(d : float) -> void:
	if not LevelManager.player: return
	
	if LevelManager.player.current_bubble == bubble: return
	
	var dir : Vector2 = global_position.direction_to(wander_point)
	velocity = velocity.move_toward(dir * bat_speed, acceleration * d)
	
func change_wander_point() -> void:
	var r : float = bubble.collision_shape_2d.shape.radius
	wander_point = bubble.global_position + Vector2(randf_range(-r, r), randf_range(-r, r))

func chase(d : float) -> void:
	if not LevelManager.player: return
	
	if not LevelManager.player.current_bubble == bubble: return
	
	var dir : Vector2 = global_position.direction_to(LevelManager.player.global_position)
	velocity = velocity.move_toward(dir * bat_speed, acceleration * d)

func die() -> void:
	$AnimationPlayer.play("die")
