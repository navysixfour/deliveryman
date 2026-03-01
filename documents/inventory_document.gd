class_name InventoryDocument

var slots: Array[InventorySlot] = []
var capacity: int = 10


class InventorySlot:
	var item: InventoryItem
	var count: int

	func _init(p_item: InventoryItem, p_count: int = 1) -> void:
		item = p_item
		count = p_count
