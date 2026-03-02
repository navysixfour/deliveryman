extends Node

@export var start_window: StringName = ""
@export var windows: Dictionary[StringName, UIWindow] = {}

var _stack: Array[UIWindow] = []


func open(window_name: StringName) -> void:
	var ui_window := windows.get(window_name) as UIWindow
	if not ui_window:
		push_warning("WindowSystem: no window registered for '%s'" % window_name)
		return

	var instance := ui_window.scene.instantiate()
	add_child(instance)
	_stack.push_back(ui_window)
	_apply_cursor(ui_window)


func close_all() -> void:
	for child in get_children():
		child.queue_free()
	_stack.clear()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func close_current() -> void:
	if _stack.is_empty():
		push_warning("WindowSystem: no current window to close.")
		return

	_stack.pop_back()
	var top := get_child(get_child_count() - 1)
	top.queue_free()

	if _stack.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		_apply_cursor(_stack.back())


func _apply_cursor(ui_window: UIWindow) -> void:
	if ui_window.hide_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
