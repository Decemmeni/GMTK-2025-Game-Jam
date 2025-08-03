extends Node
class_name LevelManagerClass

var player : Player
var max_bubbles : int = 54
var current_bubbles : int = 0
var all_bubbles : Array[Node]

func _physics_process(_delta : float) -> void:
	check_bubbles()

func check_bubbles() -> void:
	if not all_bubbles or all_bubbles.size() <= 0: return
	
	var completed : int = 0
	for b : Bubble in all_bubbles:
		if b.completed: completed += 1
	current_bubbles = completed
	print(str(completed) + " / " + str(max_bubbles))
	
	if completed >= max_bubbles:
		LoadingScreen.next_scene(load("res://Scenes/EndScreenm/end_screen.tscn"))
		all_bubbles = []
