extends Node2D
class_name CannonPowerup

@export var cannonball_speed : float = 100.0

@onready var power_up_component: PowerUpComponent = $PowerUpComponent
@onready var range_component: RangeComponent = $RangeComponent
@onready var shoot: Timer = $Shoot

const CANNONBALL = preload("res://Scenes/Enemies/Cannon/Cannonball.tscn")

func end() -> void:
	power_up_component.used()

func shootball() -> void:
	if range_component.entities.size() <= 0: return
	
	var c : CharacterBody2D = CANNONBALL.instantiate()
	var hbox_component : HitboxComponent = c.get_node_or_null("HitboxComponent")
	hbox_component.set_collision_mask_value(7, true)
	hbox_component.set_collision_mask_value(2, false)
	c.global_position = $Node2D.global_position
	c.velocity = $Node2D.global_position.direction_to(range_component.entities[0].global_position) * cannonball_speed
	get_tree().current_scene.add_child(c)
