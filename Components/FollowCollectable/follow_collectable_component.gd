extends Node
class_name FollowCollectable

@export var following_weight : float = 0.2

@onready var player : Player = get_parent()

var collectables : Array[Collectable]

func _physics_process(_delta : float) -> void:
	follow()

func follow() -> void:
	if abs(player.current_rotation_speed) <= 0: return
	
	for item in collectables.size():
		if item == 0:
			collectables[item].global_position = lerp(collectables[item].global_position, player.global_position, following_weight)
		else:
			collectables[item].global_position = lerp(collectables[item].global_position, collectables[item-1].global_position, following_weight)
