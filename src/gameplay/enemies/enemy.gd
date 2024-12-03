class_name Enemy
extends CharacterBody2D

signal died(biomat_resource: BioMatResource, position: Vector2)

@export var max_hp: int = 100
@export var speed: float = 50.0
@export var biomat_resource: BioMatResource
@export var sprite_offsets: Dictionary = { "idle": Vector2.ZERO, "run": Vector2.ZERO, "die": Vector2.ZERO }
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var raycast: RayCast2D
@export var nav_agent: NavigationAgent2D
@export var life_bar: TextureProgressBar
@export_group("States", "state_")
@export var state_machine: StateMachine
@export var state_dead: DeadEnemyState
@export var state_following: FollowingState

var current_speed: float
var current_hp: int
var _player : Player

func _ready() -> void:
	assert(biomat_resource)
	assert(coll_shape and sprite and raycast and nav_agent and life_bar)
	assert(state_machine and state_dead)
	current_hp = max_hp
	life_bar.min_value = 0
	life_bar.max_value = max_hp
	_set_life_bar_value(current_hp)
	nav_agent.debug_enabled = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player") and state_machine.get_state() is RoamEnemyState:
		_player = body
		state_machine.transition_to(state_following)


func toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)


func take_damage(damage: int):
	current_hp = clamp(current_hp - damage, 0, max_hp)
	_set_life_bar_value(current_hp)
	if current_hp == 0:
		state_machine.transition_to(state_dead)


func animate(anim: String):
	if sprite.sprite_frames.has_animation(anim) and sprite_offsets.has(anim):
		sprite.offset = sprite_offsets.get(anim)
		sprite.play(anim)


func _set_life_bar_value(value: int):
	life_bar.value = value
	life_bar.visible = life_bar.min_value < life_bar.value and life_bar.value < life_bar.max_value
