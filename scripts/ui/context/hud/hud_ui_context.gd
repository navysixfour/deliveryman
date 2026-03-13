extends UIContext

func _try_handle_input(event: InputEvent) -> bool:
	if event.is_action_pressed("pause"):
		WindowSystem.open(&"Pause")
		return true

	if event.is_action_pressed("inventory"):
		WindowSystem.open(&"Inventory")
		return true

	return false
