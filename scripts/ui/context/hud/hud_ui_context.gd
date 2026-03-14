extends UIContext

func _on_leave_context() -> void:
	_cancel_movement()
	super._on_leave_context()


func _try_handle_input(event: InputEvent) -> bool:
	if _try_handle_head_dir(event):
		return true

	if _try_handle_input_dir(event):
		return true

	if _try_handle_sprint(event):
		return true

	if _try_handle_jump(event):
		return true

	if event.is_action_pressed("pause"):
		WindowSystem.open(&"Pause")
		return true

	if event.is_action_pressed("inventory"):
		WindowSystem.open(&"Inventory")
		return true

	return false


func _try_handle_head_dir(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		World.get_player().movement.set_head_dir(event.relative)
		return true

	return false


func _try_handle_input_dir(event: InputEvent) -> bool:
	if event.is_action("move_left") or event.is_action("move_right") \
	or event.is_action("move_forward") or event.is_action("move_back"):
		World.get_player().movement.set_input_dir(
			Input.get_vector(
				"move_left",
				"move_right",
				"move_forward",
				"move_back",
			),
		)
		return true

	return false


func _try_handle_sprint(event: InputEvent) -> bool:
	if event.is_action("sprint"):
		World.get_player().movement.set_is_sprinting(event.is_pressed())
		return true

	return false


func _try_handle_jump(event: InputEvent) -> bool:
	if event.is_action_pressed("jump"):
		World.get_player().movement.set_jump_requested(true)
		return true

	return false


func _cancel_movement() -> void:
	World.get_player().movement.set_input_dir(Vector2.ZERO)
	World.get_player().movement.set_is_sprinting(false)
	World.get_player().movement.set_jump_requested(false)
