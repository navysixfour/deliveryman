extends UIContext

var view: MoneyView


func _on_enter_context(view: Node) -> void:
	self.view = view as MoneyView

	_update_money(World.get_player().money.get_money())
	World.get_player().money.money_changed.connect(_update_money)


func _on_leave_context() -> void:
	World.get_player().money.money_changed.disconnect(_update_money)


func _update_money(value: int) -> void:
	view.set_money(value)
