extends CharacterBody3D

class_name PlayerCharacter

@export var money: MoneyComponent
@export var movement: MovementComponent
@export var inventory: InventoryComponent
@export var interactions: InteractionComponent


func _ready() -> void:
	World.set_player(self)
