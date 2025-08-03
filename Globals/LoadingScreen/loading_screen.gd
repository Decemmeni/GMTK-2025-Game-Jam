extends CanvasLayer
class_name LoadingScreenClass

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var transitioning : bool = false

func reset_scene() -> void:
	if transitioning: return
	
	transitioning = true
	animation_player.play("slide")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("slide")
	await animation_player.animation_finished
	transitioning = false

func next_scene(next_scene : PackedScene) -> void:
	if transitioning: return
	
	transitioning = true
	animation_player.play("slide")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(next_scene)
	animation_player.play_backwards("slide")
	await animation_player.animation_finished
	transitioning = false
