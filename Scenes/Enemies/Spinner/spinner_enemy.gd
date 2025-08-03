extends Node2D

@export var rotation_speed : float = 1.0
@export var visual_saw_speed : float = 5.0

@onready var bubble : Bubble = get_parent()
@onready var top_blade: HitboxComponent = $TopBlade
@onready var bottom_blade: HitboxComponent = $BottomBlade
@onready var collision_shape_2d: CollisionShape2D = $TopBlade/CollisionShape2D

@onready var line_2d: Line2D = $Line2D

var dying : bool = false
var current_radian : float = 0

func _ready() -> void:
	bubble.completed_bubble.connect(destroyed)

func _physics_process(_delta : float) -> void:
	spin(_delta)
	draw()

func spin(d : float) -> void:
	if not LevelManager.player or not LevelManager.player.current_bubble == bubble: return
	if dying: return
	if not $SpinAudio.playing: $SpinAudio.playing = true
	
	current_radian += rotation_speed * d
	var blade_radius_offset : Vector2 = global_position.direction_to(global_position + Vector2(cos(current_radian), sin(current_radian))) * collision_shape_2d.shape.radius
	top_blade.global_position = global_position + Vector2(cos(current_radian), sin(current_radian)) * bubble.collision_shape_2d.shape.radius - blade_radius_offset
	bottom_blade.global_position = global_position + Vector2(cos(current_radian + PI), sin(current_radian + PI)) * bubble.collision_shape_2d.shape.radius + blade_radius_offset
	top_blade.global_rotation_degrees += visual_saw_speed
	bottom_blade.global_rotation_degrees += visual_saw_speed
	$MainBody.look_at(top_blade.global_position)

func draw() -> void:
	line_2d.points[0] = top_blade.position
	line_2d.points[1] = bottom_blade.position

func destroyed() -> void:
	dying = true
	$DeathAudio.play()
	$AnimationPlayer.play("death")
