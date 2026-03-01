extends Node

class_name InventoryPlayerSystem

signal item_added(item: InventoryItem, count: int)
signal item_removed(item: InventoryItem, count: int)
signal inventory_full()

@export var capacity: int = 10


func _ready() -> void:
	Documents.player.inventory.capacity = capacity
	PlayerSystems.inventory = self


func add_item(item: InventoryItem, count: int = 1) -> int:
	var inv := Documents.player.inventory
	var remaining := count

	for slot in inv.slots:
		if slot.item == item and slot.count < item.max_stack:
			var space := item.max_stack - slot.count
			var to_add := mini(remaining, space)
			slot.count += to_add
			remaining -= to_add
			if remaining <= 0:
				break

	while remaining > 0 and inv.slots.size() < inv.capacity:
		var to_add := mini(remaining, item.max_stack)
		inv.slots.append(InventoryDocument.InventorySlot.new(item, to_add))
		remaining -= to_add

	var added := count - remaining
	if added > 0:
		item_added.emit(item, added)
	if remaining > 0:
		inventory_full.emit()

	return added


func remove_item(item: InventoryItem, count: int = 1) -> int:
	var inv := Documents.player.inventory
	var remaining := count

	for i in range(inv.slots.size() - 1, -1, -1):
		var slot := inv.slots[i]
		if slot.item == item:
			var to_remove := mini(remaining, slot.count)
			slot.count -= to_remove
			remaining -= to_remove
			if slot.count <= 0:
				inv.slots.remove_at(i)
			if remaining <= 0:
				break

	var removed := count - remaining
	if removed > 0:
		item_removed.emit(item, removed)
	return removed


func has_item(item: InventoryItem, count: int = 1) -> bool:
	return get_item_count(item) >= count


func get_item_count(item: InventoryItem) -> int:
	var total := 0
	for slot in Documents.player.inventory.slots:
		if slot.item == item:
			total += slot.count
	return total


func is_full() -> bool:
	var inv := Documents.player.inventory
	return inv.slots.size() >= inv.capacity


func clear() -> void:
	Documents.player.inventory.slots.clear()
