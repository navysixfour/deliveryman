extends Node

var _player_character: PlayerCharacter


func set_player(chatacter: PlayerCharacter) -> void:
	assert(_player_character == null, "World: player character already set")
	_player_character = chatacter


func get_player() -> PlayerCharacter:
	return _player_character
