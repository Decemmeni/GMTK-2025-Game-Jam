extends Node2D
class_name CannonEnemy

@export var cannonball_speed : float = 200.0

@onready var barrel_end_shot: Marker2D = $Pivot/BarrelEnd/BarrelEndShot
@onready var range_component: RangeComponent = $RangeComponent
@onready var bubble : Bubble = get_parent()

var dying : bool = false
const CANNONBALL = preload("res://Scenes/Enemies/Cannon/Cannonball.tscn")

func _ready() -> void:
	bubble.completed_bubble.connect(death)

func shoot() -> void:
	if range_component.entities.size() <= 0: return
	if not LevelManager.player or not LevelManager.player.current_bubble == bubble or dying: return
	
	$AudioStreamPlayer2D.play()
	var c : CharacterBody2D = CANNONBALL.instantiate()
	c.global_position = barrel_end_shot.global_position
	c.velocity = Vector2.RIGHT.rotated(rotation) * cannonball_speed
	get_tree().current_scene.add_child(c)

func death() -> void:
	dying = true
	$AnimationPlayer.play("death")
