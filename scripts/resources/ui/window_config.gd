extends Resource

class_name WindowConfig

enum DisplayType { OVERLAY, FULLSCREEN }

@export var display_name: String = "Unnamed"
@export var scene: PackedScene
@export var show_cursor: bool = true
@export var show_background: bool = true
@export var display_type: DisplayType = DisplayType.FULLSCREEN
