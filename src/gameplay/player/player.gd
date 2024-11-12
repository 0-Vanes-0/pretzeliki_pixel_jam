class_name Player
extends CharacterBody2D

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var shoot_rate_time: float = 1.0
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var weapon_pivot: Marker2D
@export var weapon: Weapon
@export var stats: StatsManager
var current_look_direction := Vector2.RIGHT


func _ready() -> void:
	assert(coll_shape and sprite and weapon_pivot and weapon and stats)


func get_weapon_gunpoint() -> Vector2:
	return self.position + sprite.position + weapon_pivot.position + weapon.position


func toggle_collision(enable: bool):
	coll_shape.disabled = not enable
