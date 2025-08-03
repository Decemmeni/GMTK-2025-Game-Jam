extends Node
class_name SaveManagerClass

var save_path : String = "user://savefile.save"

func save_game() -> void:
	var _save_file : FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	#save_file.store_var()

func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var _file : FileAccess = FileAccess.open(save_path, FileAccess.READ)
		pass
