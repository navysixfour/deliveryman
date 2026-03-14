extends Node

class_name CharacterComponent

func _ready() -> void:
	add_to_group(Groups.PLAYER_COMPONENTS)


func cancel_input() -> void:
	pass
