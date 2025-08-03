extends CharacterBody2D
class_name MaskEnemy

@export var movement_weight : float = 0.05

@onready var bubble : Bubble = get_parent()

var activated : bool = false

func _ready() -> void:
	bubble.completed_bubble.connect(die)

func _physics_process(_delta : float) -> void:
	check_activation()
	chase()

func check_activation() -> void:
	if activated: return
	
	if not LevelManager.player or LevelManager.player.current_bubble == bubble: return
	
	activated = true

func chase() -> void:
	if not activated: return
	if not LevelManager.player: return
	
	global_position = lerp(global_position, LevelManager.player.global_position, movement_weight)

func die() -> void:
	$AnimationPlayer.play("death")
