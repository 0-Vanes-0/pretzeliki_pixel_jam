class_name Player
extends CharacterBody2D

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var speed: float = 200.0
@export var shoot_rate_time: float = 1.0
@export_group("Required Children")
@export var sprite: AnimatedSprite2D
@export var weapon_pivot: Marker2D
@export var weapon: Weapon
var current_look_direction := Vector2.RIGHT


func _ready() -> void:
	assert(sprite and weapon_pivot and weapon)


func get_weapon_gunpoint() -> Vector2:
	return self.position + sprite.position + weapon_pivot.position + weapon.position
