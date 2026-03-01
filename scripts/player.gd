extends CharacterBody3D

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003
@export var max_pitch: float = 89.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var head_pitch: float = 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	var speed := sprint_speed if Input.is_action_pressed("sprint") else move_speed
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	velocity.x = move_toward(velocity.x, 0.0, move_speed)
	velocity.z = move_toward(velocity.z, 0.0, move_speed)
	velocity += get_gravity() * delta

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		head_pitch -= event.relative.y * mouse_sensitivity
		head_pitch = clamp(head_pitch, -deg_to_rad(max_pitch), deg_to_rad(max_pitch))
		head.rotation = Vector3(head_pitch, 0.0, 0.0)
