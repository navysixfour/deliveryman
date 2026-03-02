extends CharacterBody3D

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003
@export var max_pitch: float = 89.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var head_pitch: float = 0.0
var input_dir: Vector2 = Vector2.ZERO
var is_sprinting: bool = false
var jump_requested: bool = false


func _ready() -> void:
	WindowSystem.open(WindowSystem.start_window)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		head_pitch -= event.relative.y * mouse_sensitivity
		head_pitch = clamp(head_pitch, -deg_to_rad(max_pitch), deg_to_rad(max_pitch))
		head.rotation = Vector3(head_pitch, 0.0, 0.0)

	if event.is_action("move_left") or event.is_action("move_right") \
			or event.is_action("move_forward") or event.is_action("move_back"):
		input_dir = Input.get_vector(
			"move_left", "move_right", "move_forward", "move_back"
		)

	if event.is_action("sprint"):
		is_sprinting = event.is_pressed()

	if event.is_action_pressed("jump"):
		jump_requested = true


func _physics_process(delta: float) -> void:
	var direction: Vector3 = (
		(transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	)

	var speed := sprint_speed if is_sprinting else move_speed

	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	if is_on_floor() and jump_requested:
		velocity.y = jump_velocity
	jump_requested = false

	velocity += get_gravity() * delta

	move_and_slide()
