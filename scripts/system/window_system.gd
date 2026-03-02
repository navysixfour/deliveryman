extends Node

@export var windows: Dictionary[StringName, PackedScene] = { }
@export var start_window: StringName = ""

var _stack: Array[Node] = []


func open(window_name: StringName) -> void:
	var scene := windows.get(window_name) as PackedScene
	if not scene:
		push_warning("WindowSystem: no window registered for '%s'" % window_name)
		return

	var instance := scene.instantiate()
	add_child(instance)
	_stack.push_back(instance)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close_all() -> void:
	for window in _stack:
		window.queue_free()
	_stack.clear()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func close_current() -> void:
	if _stack.is_empty():
		push_warning("WindowSystem: no current window to close.")
		return

	var top := _stack.pop_back() as Node
	top.queue_free()

	if _stack.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
