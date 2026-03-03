extends Node

@export var grid: GridContainer
@export var slot_scene: PackedScene

var _slots: Array[Control] = []


func build_grid(capacity: int) -> void:
	for child in grid.get_children():
		child.queue_free()
	_slots.clear()

	for i in capacity:
		var slot := slot_scene.instantiate() as Control
		grid.add_child(slot)
		_slots.append(slot)


func update_slots(inventory_slots: Array, capacity: int) -> void:
	for i in capacity:
		var icon: TextureRect = _slots[i].get_node("Icon")
		var count_label: Label = _slots[i].get_node("Count")

		if i < inventory_slots.size():
			var inv_slot = inventory_slots[i]
			if inv_slot.item.icon:
				icon.texture = inv_slot.item.icon
				icon.visible = true
			else:
				icon.visible = false
			count_label.text = str(inv_slot.count) if inv_slot.count > 1 else ""
			count_label.visible = inv_slot.count > 1
			_slots[i].tooltip_text = inv_slot.item.display_name
		else:
			icon.visible = false
			count_label.visible = false
			_slots[i].tooltip_text = ""
