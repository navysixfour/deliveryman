extends Node

@export var grid: GridContainer
@export var slot_scene: PackedScene

var _slot_views: Array = []


func build_grid(capacity: int) -> void:
	for child in grid.get_children():
		child.queue_free()
	_slot_views.clear()

	for i in capacity:
		var slot_view = slot_scene.instantiate()
		grid.add_child(slot_view)
		_slot_views.append(slot_view)


func update_slots(inventory_slots: Array[InventoryDocument.InventorySlot], capacity: int) -> void:
	for i in capacity:
		if i < inventory_slots.size():
			var inv_slot = inventory_slots[i]
			_slot_views[i].display(inv_slot.item.icon, inv_slot.count, inv_slot.item.display_name)
		else:
			_slot_views[i].clear()
