using Godot;

/// <summary>
/// FPS networked character controller. Handles movement, mouse look,
/// and network synchronization for multiplayer.
/// </summary>
public partial class Player : CharacterBody3D
{
	[Export] public float MoveSpeed { get; set; } = 5.0f;
	[Export] public float SprintSpeed { get; set; } = 8.0f;
	[Export] public float JumpVelocity { get; set; } = 4.5f;
	[Export] public float MouseSensitivity { get; set; } = 0.003f;
	[Export] public float MaxPitch { get; set; } = 89.0f;

	private Node3D _head = null!;
	private Camera3D _camera = null!;
	private MeshInstance3D _body = null!;
	private MultiplayerSynchronizer _synchronizer = null!;

	/// <summary>
	/// Head pitch in degrees (up/down). Synced over network.
	/// </summary>
	public float HeadPitch { get; set; }

	public override void _Ready()
	{
		_head = GetNode<Node3D>("Head");
		_camera = GetNode<Camera3D>("Head/Camera3D");
		_body = GetNode<MeshInstance3D>("Body");
		_synchronizer = GetNode<MultiplayerSynchronizer>("MultiplayerSynchronizer");

		// Setup replication config for network sync
		var config = new SceneReplicationConfig();
		config.AddProperty(new NodePath(".:global_position"));
		config.AddProperty(new NodePath(".:rotation"));
		config.AddProperty(new NodePath(".:HeadPitch"));
		_synchronizer.ReplicationConfig = config;

		// Only the local player gets camera control and sees first-person
		if (IsMultiplayerAuthority())
		{
			_camera.Current = true;
			_body.Visible = false;
			Input.MouseMode = Input.MouseModeEnum.Captured;
		}
		else
		{
			_body.Visible = true; // Show capsule for other players
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		if (!IsMultiplayerAuthority())
		{
			return;
		}

		// Movement
		Vector2 inputDir = Input.GetVector("move_left", "move_right", "move_forward", "move_back");
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();

		float speed = Input.IsActionPressed("sprint") ? SprintSpeed : MoveSpeed;
		if (direction != Vector3.Zero)
		{
			Velocity = new Vector3(direction.X * speed, Velocity.Y, direction.Z * speed);
		}
		else
		{
			Velocity = new Vector3(Mathf.MoveToward(Velocity.X, 0, speed), Velocity.Y,
				Mathf.MoveToward(Velocity.Z, 0, speed));
		}

		if (IsOnFloor() && Input.IsActionJustPressed("jump"))
		{
			Velocity = Velocity with { Y = JumpVelocity };
		}

		Velocity += GetGravity() * (float)delta;
		MoveAndSlide();
	}

	public override void _Input(InputEvent ev)
	{
		if (!IsMultiplayerAuthority()) return;

		if (ev is InputEventMouseMotion mouseMotion)
		{
			// Yaw (left/right) - rotate body
			RotateY(-mouseMotion.Relative.X * MouseSensitivity);

			// Pitch (up/down) - rotate head only
			HeadPitch -= mouseMotion.Relative.Y * MouseSensitivity;
			HeadPitch = Mathf.Clamp(HeadPitch, -Mathf.DegToRad(MaxPitch), Mathf.DegToRad(MaxPitch));
			_head.Rotation = new Vector3(HeadPitch, 0, 0);
		}
	}

	public override void _Process(double delta)
	{
		// Apply synced head pitch on remote peers
		if (!IsMultiplayerAuthority())
		{
			_head.Rotation = new Vector3(HeadPitch, 0, 0);
		}
	}
}
