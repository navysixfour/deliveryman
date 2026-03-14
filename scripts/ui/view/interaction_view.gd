extends Control

class_name InteractionView

@export var label: Label
@export var icon: TextureRect


func show_interaction(text: String, texture: Texture2D) -> void:
	label.text = text
	if texture:
		icon.texture = texture
		icon.visible = true
	else:
		icon.visible = false
	visible = true


func hide_interaction() -> void:
	visible = false
