extends Node

class_name MoneyPlayerSystem

@export var starting_money: int = 100
signal money_changed(new_amount: int, delta: int)


func _ready() -> void:
	Documents.player.money = starting_money
	PlayerSystems.money = self


func add_money(amount: int) -> void:
	if amount <= 0:
		return
	Documents.player.money += amount
	money_changed.emit(Documents.player.money, amount)


func try_spend_money(amount: int) -> bool:
	if can_afford(amount) == false:
		return false
	Documents.player.money -= amount
	money_changed.emit(Documents.player.money, -amount)
	return true


func can_afford(amount: int) -> bool:
	return amount >= 0 and Documents.player.money >= amount
