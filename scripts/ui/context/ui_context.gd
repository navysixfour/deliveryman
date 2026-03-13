@abstract
class_name UIContext
extends Node

func _on_enter_context(view: Node):
	pass


func _on_leave_context():
	pass


func _unhandled_input(event: InputEvent) -> void:
	var viewport = get_viewport()
	if _try_handle_input(event):
		viewport.set_input_as_handled()


func _try_handle_input(event: InputEvent) -> bool:
	return false


func _enter_tree() -> void:
	var view = get_child(0)
	_on_enter_context(view)


func _exit_tree() -> void:
	_on_leave_context()
