extends Node

@export var window_to_open: String


func _ready() -> void:
	WindowSystem.open(window_to_open)
