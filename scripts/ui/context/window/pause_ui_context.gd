extends FullscreenUIContext

func _on_button_resume_pressed() -> void:
	WindowSystem.close_current()


func _on_button_options_pressed() -> void:
	WindowSystem.open(&"Options")


func _on_button_quit_pressed() -> void:
	get_tree().quit()
