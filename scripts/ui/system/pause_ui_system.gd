extends Control

func _ready() -> void:
	pass

func _on_resume() -> void:
	pass

func _on_quit() -> void:
	get_tree().quit()

func _on_button_resume_pressed() -> void:
	_on_resume()

func _on_button_quit_pressed() -> void:
	_on_quit()
