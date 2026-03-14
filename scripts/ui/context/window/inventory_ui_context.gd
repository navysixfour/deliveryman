extends FullscreenUIContext

var view: InventoryView


func _on_enter_context(view: Node) -> void:
	super._on_enter_context(view)

	self.view = view as InventoryView

	view.build_grid(World.get_player().inventory.capacity)
	_refresh()

	World.get_player().inventory.item_added.connect(_on_inventory_changed)
	World.get_player().inventory.item_removed.connect(_on_inventory_changed)


func _on_leave_context() -> void:
	World.get_player().inventory.item_added.disconnect(_on_inventory_changed)
	World.get_player().inventory.item_removed.disconnect(_on_inventory_changed)

	super._on_leave_context()


func _on_inventory_changed(_item: InventoryItem, _count: int) -> void:
	_refresh()


func _refresh() -> void:
	var inv = World.get_player().inventory.get_all()
	view.update_slots(inv.slots, World.get_player().inventory.capacity)
