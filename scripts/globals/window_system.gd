extends Node

@export var config: WindowsConfig
@export var window_background: PackedScene

var _container: Node
var _stack: Array = []
var _window_background: Node

func set_container(container: Node) -> void:
	_container = container
	

func open(window_name: StringName) -> void:
	var ui_window := config.windows.get(window_name) as WindowConfig
	if not ui_window:
		push_warning("WindowSystem: no window registered for '%s'" % window_name)
		return

	_apply_cursor(ui_window)
	_apply_background(ui_window)

	if ui_window.display_type == WindowConfig.DisplayType.FULLSCREEN:
		_set_top_fullscreen_visible(false)

	var instance := ui_window.scene.instantiate()
	_stack.push_back({ "config": ui_window, "instance": instance })
	_container.add_child(instance)


func close_current() -> void:
	if _stack.is_empty():
		push_warning("WindowSystem: no current window to close.")
		return

	var entry: Dictionary = _stack.pop_back()
	entry.instance.queue_free()

	if entry.config.display_type == WindowConfig.DisplayType.FULLSCREEN:
		_set_top_fullscreen_visible(true)

	if _stack.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		_apply_cursor(_stack.back().config)
		_apply_background(_stack.back().config)


func _apply_cursor(ui_window: WindowConfig) -> void:
	if ui_window.show_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _apply_background(ui_window: WindowConfig) -> void:
	if ui_window.show_background:
		if not _window_background:
			_window_background = window_background.instantiate()
			_container.add_child(_window_background)
	elif _window_background:
		_window_background.queue_free()
		_window_background = null


func _set_top_fullscreen_visible(visible: bool) -> void:
	for i in range(_stack.size() - 1, -1, -1):
		if _stack[i].config.display_type == WindowConfig.DisplayType.FULLSCREEN:
			if visible:
				_container.add_child(_stack[i].instance)
			else:
				_container.remove_child(_stack[i].instance)
			break
