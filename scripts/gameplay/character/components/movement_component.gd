extends CharacterComponent

class_name MovementComponent

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003
@export var max_pitch: float = 89.0

@export var head: Node3D
@export var camera: Camera3D
@export var player: CharacterBody3D

var _head_pitch: float = 0.0
var _input_dir: Vector2 = Vector2.ZERO
var _is_sprinting: bool = false
var _jump_requested: bool = false


func set_input_dir(dir: Vector2) -> void:
	_input_dir = dir


func set_is_sprinting(is_sprinting: bool) -> void:
	_is_sprinting = is_sprinting


func set_jump_requested(jump_requested: bool) -> void:
	_jump_requested = jump_requested


func set_head_dir(head_dir: Vector2) -> void:
	player.rotate_y(-head_dir.x * mouse_sensitivity)
	_head_pitch -= head_dir.y * mouse_sensitivity
	_head_pitch = clamp(_head_pitch, -deg_to_rad(max_pitch), deg_to_rad(max_pitch))
	head.rotation = Vector3(_head_pitch, 0.0, 0.0)


func _physics_process(delta: float) -> void:
	var direction: Vector3 = (
		(player.transform.basis * Vector3(_input_dir.x, 0.0, _input_dir.y)).normalized()
	)

	var speed := sprint_speed if _is_sprinting else move_speed

	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0.0, speed)

	if player.is_on_floor() and _jump_requested:
		player.velocity.y = jump_velocity
	_jump_requested = false

	player.velocity += player.get_gravity() * delta

	player.move_and_slide()
