extends Node2D

func _ready() -> void:
	LevelManager.all_bubbles = $BubblesFolder.get_children()
	print(LevelManager.all_bubbles)
