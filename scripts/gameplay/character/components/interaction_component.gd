extends CharacterComponent
class_name InteractionComponent

var _interaction_targets: Array[Area3D] = []


func add_interactable(target: Interactable3D) -> void:
	assert(
		not _interaction_targets.has(target),
		"InteractionInstigator: target already added '%s'" % target.name,
	)

	_interaction_targets.push_back(target)


func remove_interactable(target: Interactable3D) -> void:
	assert(
		_interaction_targets.has(target),
		"InteractionInstigator: target not found '%s'" % target.name,
	)

	_interaction_targets.erase(target)
