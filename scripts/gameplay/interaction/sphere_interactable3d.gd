@tool
extends Interactable3D

class_name SphereInteractable3D

@export var collision_shape: CollisionShape3D:
	set(value):
		collision_shape = value
		_update_collision_radius()

@export var interaction_radius: float = 2.0:
	set(value):
		interaction_radius = value
		_update_collision_radius()


func _update_collision_radius() -> void:
	if collision_shape and collision_shape.shape:
		collision_shape.shape.radius = interaction_radius


func _ready() -> void:
	_update_collision_radius()
	super._ready()
