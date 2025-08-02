extends CharacterBody2D
class_name Player

@export var max_rotation_speed : float = 2.5
@export var extra_rotation_speed : float = 0
@export var base_radius : float = 80.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.1
@export var current_bubble : Bubble

@onready var camera_2d: Camera2D = $CameraPivot/Camera2D
@onready var slide_player: AudioStreamPlayer2D = $SlidePlayer
@onready var bubble_transition_player: AudioStreamPlayer2D = $BubbleTransitionPlayer
@onready var follow_collectable_component: FollowCollectable = $FollowCollectableComponent


var current_rotation_speed : float = 0.0
var next_bubble : Bubble

var current_radian : float = 0

signal switched_bubble

enum states {
	IDLE,
	ACCELERATING
}

func _ready() -> void:
	LevelManager.player = self
	switch_camera()

func _physics_process(_delta: float) -> void:
	switch_bubble()
	play_slide(_delta)
	move(_delta)
	

func move(d : float) -> void:
	if not current_bubble: 
		push_warning("Bubble not selected")
		return
	
	var origin : Vector2 = current_bubble.collision_shape_2d.global_position
	var inner_layer : Vector2 = Vector2(cos(current_radian), sin(current_radian)) * current_bubble.collision_shape_2d.shape.radius
	global_position =  origin + inner_layer
	
	current_radian += current_rotation_speed
	current_bubble.current_completion += current_rotation_speed
	current_bubble.line.add_point(current_bubble.to_local(global_position))
	
	var dir : float = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	if not dir: 
		current_rotation_speed = move_toward(current_rotation_speed, 0, deceleration * d)
		return
	
	var speed_multiplier : float = base_radius / current_bubble.collision_shape_2d.shape.radius # Make sure larger bubbles take longer
	var end_speed : float = dir * (max_rotation_speed + extra_rotation_speed) * d * speed_multiplier
	current_rotation_speed = move_toward(current_rotation_speed ,end_speed, acceleration * d)
	
	

func switch_bubble() -> void:
	current_bubble.area_2d.set_collision_layer_value(3, false)
	current_bubble.area_2d.set_collision_layer_value(4, true)
	
	if not Input.is_action_just_pressed("switch bubble") or not next_bubble or not current_bubble.completed: return
	
	current_bubble.area_2d.set_collision_layer_value(3, true)
	current_bubble.area_2d.set_collision_layer_value(4, false)
	current_bubble = next_bubble
	current_radian += PI
	bubble_transition_player.play()
	switched_bubble.emit()
	

func _on_bubble_detector_area_entered(area: Area2D) -> void:
	if next_bubble: return
	next_bubble = area.get_parent()


func _on_bubble_detector_area_exited(_area: Area2D) -> void:
	if not next_bubble: return
	next_bubble = null

func switch_camera() -> void:
	camera_2d.global_position = current_bubble.global_position

func play_slide(_d : float) -> void:
	#print(slide_player.volume_db)

	var dir : float = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	if dir and ((dir > 0 and current_rotation_speed > 0 or (dir < 0 and current_rotation_speed < 0))):
		slide_player.volume_db = move_toward(slide_player.volume_db, abs(current_rotation_speed / max_rotation_speed), 1.5)
	else:
		slide_player.volume_db = move_toward(slide_player.volume_db, -40, 1)
