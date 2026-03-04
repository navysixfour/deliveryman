@abstract
class_name UIContext
extends Node

var view: Node


func _init() -> void:
	view = get_child(0)
