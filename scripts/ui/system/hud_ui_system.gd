extends Node

@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		WindowSystem.open(&"Pause")


func _on_layer_blocked(layer: StringName) -> void:
	if layer == &"Hud":
		canvas_layer.visible = false


func _on_layer_unblocked(layer: StringName) -> void:
	if layer == &"Hud":
		canvas_layer.visible = true
