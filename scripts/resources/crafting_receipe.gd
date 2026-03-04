extends Resource

class_name CraftingReceipe

@export var ingredients: Dictionary[InventoryItem, int]
@export var result_item: InventoryItem
@export var crafting_time: int
