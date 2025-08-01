extends Collectable
class_name TreasureCollectable

@export var powerup_scene : PackedScene

@onready var particles: CPUParticles2D = $Particles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bubble : Bubble = get_parent()

func _ready() -> void:
	bubble.completed_bubble.connect(collect)

func collect() -> void:
	animation_player.play("collected")
