extends PanelContainer

class_name InventorySlotView
@export var icon_rect: TextureRect
@export var count_label: Label


func display(icon: Texture2D, count: int, tooltip: String) -> void:
	icon_rect.texture = icon
	icon_rect.visible = icon != null
	count_label.text = str(count) if count > 1 else ""
	count_label.visible = count > 1
	tooltip_text = tooltip


func clear() -> void:
	icon_rect.visible = false
	count_label.visible = false
	tooltip_text = ""
