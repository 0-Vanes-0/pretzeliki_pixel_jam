## Singleton for converting resources paths to variables.
extends Node

@export_group("Screens", "screen_")

@export_group("Game Objects")
@export var blaster_projectile: PackedScene
@export var biomat: PackedScene
@export var grenade: PackedScene
@export var root_ability: PackedScene

@export_group("UIs")


func _ready() -> void:
	assert(blaster_projectile and biomat and grenade and root_ability)
