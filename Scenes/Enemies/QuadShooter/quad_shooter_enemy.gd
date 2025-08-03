extends CharacterBody2D
class_name QuadShooterEnemy

@export var move_radius : float = 20.0
@export var cannon_ball_speed : float = 150.0

@onready var bubble : Bubble = get_parent()
@onready var next_point : Vector2 = global_position
@onready var ends_children: Array[Node] = $Ends.get_children()


var current_rotate : float = 0.0
const CANNONBALL = preload("res://Scenes/Enemies/Cannon/Cannonball.tscn")

func _ready() -> void:
	bubble.completed_bubble.connect(death)

func _physics_process(_delta : float) -> void:
	global_position = lerp(global_position, next_point, 0.02)
	rotation = lerp_angle(global_rotation, current_rotate, 0.2)

func shoot() -> void:
	if not LevelManager.player or not LevelManager.player.current_bubble == bubble: return
	
	current_rotate += deg_to_rad(45.0)
	$AudioStreamPlayer2D.play()
	for i in 4:
		var c : CharacterBody2D = CANNONBALL.instantiate()
		c.global_position = ends_children[i].global_position
		c.velocity = global_position.direction_to(ends_children[i].global_position) * cannon_ball_speed
		get_tree().current_scene.add_child(c)

func wander() -> void:
	if not bubble or not bubble.collision_shape_2d: return
	
	next_point = bubble.global_position + Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * move_radius

func death() -> void:
	$AnimationPlayer.play("death")
