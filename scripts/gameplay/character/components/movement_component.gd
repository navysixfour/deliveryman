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


func cancel_input() -> void:
	_input_dir = Vector2.ZERO
	_is_sprinting = false
	_jump_requested = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sensitivity)

		_head_pitch -= event.relative.y * mouse_sensitivity
		_head_pitch = clamp(_head_pitch, -deg_to_rad(max_pitch), deg_to_rad(max_pitch))
		head.rotation = Vector3(_head_pitch, 0.0, 0.0)

	if event.is_action("move_left") or event.is_action("move_right") \
	or event.is_action("move_forward") or event.is_action("move_back"):
		_input_dir = Input.get_vector(
			"move_left",
			"move_right",
			"move_forward",
			"move_back",
		)

	if event.is_action("sprint"):
		_is_sprinting = event.is_pressed()

	if event.is_action_pressed("jump"):
		_jump_requested = true


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
