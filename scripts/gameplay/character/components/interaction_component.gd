extends CharacterComponent

class_name InteractionComponent

signal target_changed(target: Interactable3D)

@export var camera: Camera3D
@export var max_look_angle: float = 15.0

var _interaction_targets: Array[Interactable3D] = []
var _current_target: Interactable3D = null


func _physics_process(_delta: float) -> void:
	var new_target := _find_looked_at_target()
	if new_target != _current_target:
		_current_target = new_target
		target_changed.emit(_current_target)


func add_interactable(target: Interactable3D) -> void:
	assert(_interaction_targets.has(target) == false, "Target already added: %s" % target.name)

	_interaction_targets.push_back(target)


func remove_interactable(target: Interactable3D) -> void:
	assert(_interaction_targets.has(target), "Target not found: %s" % target.name)

	_interaction_targets.erase(target)
	if _current_target == target:
		_current_target = null
		target_changed.emit(null)


func get_current_target() -> Interactable3D:
	return _current_target


func _find_looked_at_target() -> Interactable3D:
	if _interaction_targets.is_empty() or not camera:
		return null

	var cam_pos := camera.global_position
	var cam_forward := -camera.global_basis.z
	var threshold := cos(deg_to_rad(max_look_angle))

	var best_target: Interactable3D = null
	var best_dot := threshold

	for target in _interaction_targets:
		if not is_instance_valid(target):
			continue
		var to_target := (target.global_position - cam_pos).normalized()
		var dot := cam_forward.dot(to_target)
		if dot > best_dot:
			best_dot = dot
			best_target = target

	return best_target
