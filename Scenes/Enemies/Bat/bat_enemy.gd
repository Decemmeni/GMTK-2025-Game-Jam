extends CharacterBody2D
class_name BatEnemy

@export var bat_speed : float = 200.0
@export var acceleration : float = 40.0

@onready var bubble : Bubble = get_parent()
@onready var wander_point: Vector2 = bubble.global_position

var dead : bool = false


func _ready() -> void:
	bubble.completed_bubble.connect(die)

func _physics_process(_delta : float) -> void:
	chase(_delta)
	move_and_slide()

func chase(_d : float) -> void:
	if not LevelManager.player: return
	
	if not LevelManager.player.current_bubble == bubble: return
	
	if not $MovementSound.playing : $MovementSound.playing = true
	
	var dir : Vector2 = global_position.direction_to(LevelManager.player.global_position)
	velocity = lerp(velocity, dir * bat_speed, 0.02)

func die() -> void:
	$DeathSound.play()
	$AnimationPlayer.play("die")
