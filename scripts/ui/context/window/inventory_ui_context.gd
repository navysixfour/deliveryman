extends FullscreenUIContext

var view: InventoryView


func _on_enter_context(view: Node) -> void:
	self.view = view as InventoryView

	view.build_grid(PlayerSystems.inventory.capacity)
	_refresh()

	PlayerSystems.inventory.item_added.connect(_on_inventory_changed)
	PlayerSystems.inventory.item_removed.connect(_on_inventory_changed)


func _on_leave_context() -> void:
	PlayerSystems.inventory.item_added.disconnect(_on_inventory_changed)
	PlayerSystems.inventory.item_removed.disconnect(_on_inventory_changed)


func _on_inventory_changed(_item: InventoryItem, _count: int) -> void:
	_refresh()


func _refresh() -> void:
	var inv = PlayerSystems.inventory.get_all()
	view.update_slots(inv.slots, PlayerSystems.inventory.capacity)
