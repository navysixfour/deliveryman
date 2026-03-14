@abstract
class_name FullscreenUIContext
extends UIContext


func _try_handle_input(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		WindowSystem.close_current()
	return true
