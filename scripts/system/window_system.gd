extends Node

@export var windows: Dictionary[StringName, PackedScene] = {}

var _stack: Array[Node] = []

func open(name: StringName) -> void:
	var scene := windows.get(name) as PackedScene
	if not scene:
		push_warning("WindowSystem: no window registered for '%s'" % name)
		return

	var instance := scene.instantiate()
	add_child(instance)
	_stack.push_back(instance)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close_current() -> void:
	if _stack.is_empty():
		return

	var top := _stack.pop_back() as Node
	top.queue_free()

	if _stack.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
