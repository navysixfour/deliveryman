extends Area3D

class_name Interactable3D

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		body.interactions.add_interactable(self)


func on_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		body.interactions.remove_interactable(self)
