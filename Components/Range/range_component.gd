extends Area2D
class_name RangeComponent

# Don't forget to set collision mask, no collision layer

var entities : Array[Node2D]

func _on_body_entered(body: Node2D) -> void:
	entities.append(body)


func _on_body_exited(body: Node2D) -> void:
	entities.remove_at(entities.find(body))
