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
@export_group("States", "state_")
@export var state_machine: StateMachine
@export var state_run_and_gun: RunAndGunPlayerState
@export var state_terminal: TerminalPlayerState

var current_look_direction := Vector2.RIGHT


func _ready() -> void:
	assert(coll_shape and sprite and weapon_pivot and weapon and stats)
	assert(state_machine and state_run_and_gun and state_terminal)


func get_weapon_gunpoint() -> Vector2:
	return self.position + sprite.position + weapon_pivot.position + weapon.position


func toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)


func take_damage(damage: float):
	pass
