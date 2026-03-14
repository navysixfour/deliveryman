@abstract
class_name FullscreenUIContext
extends UIContext

func _on_enter_context(view: Node) -> void:
	get_tree().call_group(Groups.PLAYER_SYSTEMS, "cancel_input")


func _try_handle_input(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		WindowSystem.close_current()
	return true
