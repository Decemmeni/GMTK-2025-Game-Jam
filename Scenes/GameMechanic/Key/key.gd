extends Collectable
class_name KeyCollectable

@onready var bubble : Bubble = get_parent()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	bubble.completed_bubble.connect(collect)

func collect() -> void:
	animation_player.play("collected")
	await animation_player.animation_finished
	LevelManager.player.follow_collectable_component.collectables.append(self)
