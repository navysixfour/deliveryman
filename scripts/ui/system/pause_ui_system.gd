extends Node

func _input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()


func _on_button_resume_pressed() -> void:
	WindowSystem.close_current()


func _on_button_options_pressed() -> void:
	WindowSystem.open(&"Options")
