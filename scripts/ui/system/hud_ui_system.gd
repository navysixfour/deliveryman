extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		WindowSystem.open(&"Pause")
	elif event.is_action_pressed("inventory"):
		WindowSystem.open(&"Inventory")
