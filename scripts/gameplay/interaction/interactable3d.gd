extends Area3D

class_name Interactable3D

@export var interaction_text: String = "Interact"
@export var interaction_icon: Texture2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		body.interactions.add_interactable(self)


func _on_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		body.interactions.remove_interactable(self)


func interact(player: PlayerCharacter) -> void:
	pass
