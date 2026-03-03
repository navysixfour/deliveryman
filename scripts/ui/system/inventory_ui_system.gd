extends WindowUISystem

var _view: Node


func _ready() -> void:
	_view = get_child(0)
	var inv := Documents.player.inventory
	_view.build_grid(inv.capacity)
	_refresh()
	PlayerSystems.inventory.item_added.connect(_on_inventory_changed)
	PlayerSystems.inventory.item_removed.connect(_on_inventory_changed)


func _exit_tree() -> void:
	if PlayerSystems.inventory:
		PlayerSystems.inventory.item_added.disconnect(_on_inventory_changed)
		PlayerSystems.inventory.item_removed.disconnect(_on_inventory_changed)


func _on_inventory_changed(_item: InventoryItem, _count: int) -> void:
	_refresh()


func _refresh() -> void:
	var inv := Documents.player.inventory
	_view.update_slots(inv.slots, inv.capacity)
