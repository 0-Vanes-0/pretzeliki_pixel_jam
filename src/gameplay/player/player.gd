class_name Player
extends CharacterBody2D

signal entered_terminal
signal exited_terminal

@export var shoot_rate_time: float = 1.0
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var weapon_pivot: Marker2D
@export var weapon: Weapon
@export var hands: AnimatedSprite2D
@export var gunpoint: Marker2D
@export var stats: StatsManager
@export_group("States", "state_")
@export var state_machine: StateMachine
@export var state_run_and_gun: RunAndGunPlayerState
@export var state_terminal: TerminalPlayerState

var current_look_direction := Vector2.RIGHT


func _ready() -> void:
	assert(coll_shape and sprite and weapon_pivot and weapon and stats and gunpoint and hands)
	assert(state_machine and state_run_and_gun and state_terminal)


func get_weapon_gunpoint() -> Vector2:
	var s := sprite.scale.x
	return (
			sprite.position
			+ Vector2(weapon_pivot.position.x * s, weapon_pivot.position.y)
			+ Vector2(weapon.position.x * s, weapon.position.y).rotated(weapon_pivot.rotation * s)
			+ Vector2(gunpoint.position.x * s, gunpoint.position.y).rotated(weapon_pivot.rotation * s)
	)


func toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)


func take_damage(damage: int):
	if stats.current_armor > 0:
		stats.adjust_health(-1)
		stats.adjust_armor(-1)
	else:
		stats.adjust_health(- damage)
	# TODO: add short invulnerable delay ~0.5 sec


func has_dash_ability() -> bool:
	return stats.dash_reload_time > 0


func has_stun_ability() -> bool:
	return stats.stun_reload_time > 0


func has_armor_ability() -> bool:
	return stats.max_armor > 0


func animate(anim: String):
	var suffix: String = (
			"_sim" if Global.suit_state == "simulation"
			else "_suitless" if Global.suit_state == "ship_naked"
			else "_suit"
	)
	if sprite.sprite_frames.has_animation(anim + suffix):
		sprite.play(anim + suffix)
