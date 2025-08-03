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

# GUI
@onready var progress_bar: ProgressBar = $PlayerGUI/ProgressBar


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
	$PlayerGUI/ProgressBar.max_value = $HealthComponent.max_health
	switch_camera()

func _physics_process(_delta: float) -> void:
	switch_bubble()
	play_slide(_delta)
	move(_delta)
	update_health_bar()

func move(d : float) -> void:
	if not current_bubble:
		push_warning("Bubble not selected")
		return
	
	var origin : Vector2 = current_bubble.collision_shape_2d.global_position
	var inner_layer : Vector2 = Vector2(cos(current_radian), sin(current_radian)) * current_bubble.collision_shape_2d.shape.radius
	global_position =  origin + inner_layer
	global_rotation = Vector2(cos(current_radian - PI/2), sin(current_radian - PI/2)).angle()
	
	current_radian += current_rotation_speed
	#current_radian = wrapf(current_radian, -2*PI, 2*PI)
	current_bubble.current_completion += current_rotation_speed
	#print(deg_to_rad(current_bubble.max_right) > current_radian)
	if current_rotation_speed > 0 and deg_to_rad(current_bubble.max_left) < current_radian: # Clockwise
		current_bubble.max_left += rad_to_deg(current_rotation_speed)
	elif current_rotation_speed < 0 and deg_to_rad(current_bubble.max_right) > current_radian: # Counter Clockwise
		current_bubble.max_right += rad_to_deg(current_rotation_speed)
	
	var dir : float = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	if not dir: 
		current_rotation_speed = move_toward(current_rotation_speed, 0, deceleration * d)
		return
	
	var speed_multiplier : float = base_radius / current_bubble.collision_shape_2d.shape.radius # Make sure larger bubbles take longer
	var end_speed : float = dir * (max_rotation_speed + extra_rotation_speed) * d * speed_multiplier
	current_rotation_speed = move_toward(current_rotation_speed ,end_speed, acceleration * d)
	
	

func switch_bubble() -> void:
	if not current_bubble: return
	
	current_bubble.area_2d.set_collision_layer_value(3, false)
	current_bubble.area_2d.set_collision_layer_value(4, true)
	
	if not Input.is_action_just_pressed("switch bubble") or not next_bubble or not current_bubble.completed: return
	
	current_bubble.area_2d.set_collision_layer_value(3, true)
	current_bubble.area_2d.set_collision_layer_value(4, false)
	current_bubble = next_bubble
	current_radian += PI
	current_radian = wrapf(current_radian, -2*PI, 2*PI)
	current_bubble.start_pos = rad_to_deg(current_radian)
	current_bubble.max_left = rad_to_deg(current_radian)
	current_bubble.max_right = rad_to_deg(current_radian)
	bubble_transition_player.play()
	switched_bubble.emit()
	

func _on_bubble_detector_area_entered(area: Area2D) -> void:
	if next_bubble: return
	next_bubble = area.get_parent()


func _on_bubble_detector_area_exited(_area: Area2D) -> void:
	if not next_bubble: return
	next_bubble = null

func switch_camera() -> void:
	if not current_bubble: return
	
	camera_2d.global_position = current_bubble.global_position

func play_slide(_d : float) -> void:
	#print(slide_player.volume_db)

	var dir : float = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	if dir and ((dir > 0 and current_rotation_speed > 0 or (dir < 0 and current_rotation_speed < 0))):
		slide_player.volume_db = move_toward(slide_player.volume_db, abs(current_rotation_speed / max_rotation_speed), 1.5)
	else:
		slide_player.volume_db = move_toward(slide_player.volume_db, -40, 1)

func play_hurt() -> void:
	$HurtNoise.play()

func die() -> void:
	$DeathNoise.play()
	LoadingScreen.reset_scene()

func update_health_bar() -> void:
	progress_bar.value = $HealthComponent.current_health
