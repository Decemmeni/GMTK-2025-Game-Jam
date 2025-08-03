extends CharacterBody2D

@export var npc_resource : NPCResource
@export var sprite_size : Vector2 = Vector2(1,1)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bubble : Bubble = get_parent()
@onready var range_component: RangeComponent = $RangeComponent

var r : Resource = load("res://Dialogues/TestNPC/testintro.dialogue")
var current_dialog : Node

func _ready() -> void:
	sprite_2d.texture = npc_resource.texture
	sprite_2d.scale = sprite_size

func _physics_process(_delta : float) -> void:
	check_talk()

func check_talk() -> void:
	if range_component.entities.size() <= 0: return
	
	if not Input.is_action_just_pressed("talk"): return
	
	if not current_dialog:
		current_dialog = DialogueManager.show_dialogue_balloon(npc_resource.dialog)
