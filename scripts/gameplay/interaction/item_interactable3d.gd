@tool
extends SphereInteractable3D

class_name ItemInteractable3D

@export var item: InventoryItem
@export var quantity: int = 1


func interact(player: PlayerCharacter) -> void:
	if not item:
		return
	player.inventory.add_item(item, quantity)
	queue_free()
