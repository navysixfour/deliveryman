extends Node
var _view: MoneyView


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_view = get_child(0)
	_on_enable()


func _exit_tree() -> void:
	_on_disable()

	
func _on_enable() -> void:
	_update_money(Documents.player.money)
	PlayerSystems.money.money_changed.connect(_update_money)


func _on_disable() -> void:
	PlayerSystems.money.money_changed.disconnect(_update_money)


func _update_money(value: int) -> void:
	_view.set_money(value)
