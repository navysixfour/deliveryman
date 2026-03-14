extends Node

class_name PlayerSystem

func _ready() -> void:
	add_to_group(Groups.PLAYER_SYSTEMS)


func cancel_input() -> void:
	pass
