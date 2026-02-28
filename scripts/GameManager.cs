using Godot;

/// <summary>
/// Handles multiplayer host/join and player spawning.
/// Attach to the root of the main game scene.
/// </summary>
public partial class GameManager : Node
{
	private const int DefaultPort = 7777;

	[Export] public PackedScene PlayerScene { get; set; } = null!;

	private Node3D _spawnPoint = null!;
	private Node _playersContainer = null!;
	private ENetMultiplayerPeer _peer = null!;
	private MultiplayerSpawner _spawner = null!;
	private Control _mainMenu = null!;

	public override void _Ready()
	{
		_spawnPoint = GetNode<Node3D>("SpawnPoint");
		_playersContainer = GetNode<Node>("Players");
		_mainMenu = GetParent().GetNode<Control>("MainMenu");
		_spawner = GetNode<MultiplayerSpawner>("MultiplayerSpawner");
		_spawner.AddSpawnableScene("res://scenes/player/player.tscn");

		Multiplayer.PeerConnected += OnPeerConnected;
		Multiplayer.PeerDisconnected += OnPeerDisconnected;
		Multiplayer.ConnectedToServer += OnConnectedToServer;
		Multiplayer.ConnectionFailed += OnConnectionFailed;
		Multiplayer.ServerDisconnected += OnServerDisconnected;
	}

	public void HostGame()
	{
		_peer = new ENetMultiplayerPeer();
		var err = _peer.CreateServer(DefaultPort, 8);
		if (err != Error.Ok)
		{
			GD.PushError($"Failed to create server: {err}");
			return;
		}

		Multiplayer.MultiplayerPeer = _peer;
		GD.Print($"Server started on port {DefaultPort}");
		SpawnPlayer(Multiplayer.GetUniqueId());
	}

	public void JoinGame(string address = "127.0.0.1")
	{
		_peer = new ENetMultiplayerPeer();
		var err = _peer.CreateClient(address, DefaultPort);
		if (err != Error.Ok)
		{
			GD.PushError($"Failed to connect: {err}");
			return;
		}

		Multiplayer.MultiplayerPeer = _peer;
		GD.Print($"Connecting to {address}:{DefaultPort}...");
	}

	private void OnPeerConnected(long id)
	{
		GD.Print($"Peer connected: {id}");
		SpawnPlayer(id);
	}

	private void OnPeerDisconnected(long id)
	{
		GD.Print($"Peer disconnected: {id}");
		foreach (Node child in _playersContainer.GetChildren())
		{
			if (child is Player player && player.GetMultiplayerAuthority() == (int)id)
			{
				player.QueueFree();
				break;
			}
		}
	}

	private void OnConnectedToServer()
	{
		GD.Print("Connected to server!");
	}

	private void OnConnectionFailed()
	{
		GD.PushError("Connection failed!");
		Multiplayer.MultiplayerPeer = null;
		_mainMenu.Visible = true;
	}

	private void OnServerDisconnected()
	{
		GD.Print("Server disconnected");
		Multiplayer.MultiplayerPeer = null;
		GetTree().ChangeSceneToFile("res://scenes/main/main.tscn");
	}

	private void SpawnPlayer(long id)
	{
		var player = PlayerScene.Instantiate<Player>();
		player.Name = $"Player_{id}";
		player.SetMultiplayerAuthority((int)id);

		player.GlobalPosition = _spawnPoint.GlobalPosition;
		_playersContainer.AddChild(player, true);
	}

	private void _on_host_pressed()
	{
		HostGame();
		_mainMenu.Visible = false;
	}

	private void _on_join_pressed()
	{
		JoinGame();
		_mainMenu.Visible = false;
	}
}
