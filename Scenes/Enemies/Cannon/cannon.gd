extends Node2D
class_name CannonEnemy

@export var cannonball_speed : float = 200.0

@onready var barrel_end_shot: Marker2D = $Pivot/BarrelEnd/BarrelEndShot
@onready var range_component: RangeComponent = $RangeComponent

const CANNONBALL = preload("res://Scenes/Enemies/Cannon/Cannonball.tscn")

func shoot() -> void:
	if range_component.entities.size() <= 0: return
	
	var c : CharacterBody2D = CANNONBALL.instantiate()
	c.global_position = barrel_end_shot.global_position
	c.velocity = Vector2.RIGHT.rotated(rotation) * cannonball_speed
	get_tree().current_scene.add_child(c)
