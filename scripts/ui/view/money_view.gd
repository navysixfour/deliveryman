extends Node

class_name MoneyView

@export var label: Label


func set_money(value: int) -> void:
	label.text = str(value)
