class_name Enemy
extends CharacterBody2D

signal died(biomat_resource: BioMatResource, position: Vector2)

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var speed: float = 50.0
@export var biomat_resource: BioMatResource
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var raycast: RayCast2D
@export_group("States", "state_")
@export var state_machine: StateMachine
@export var state_dead: DeadEnemyState
@export var state_following: FollowingState

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var current_speed: float
var _additional_forces: Array[Vector2]
var _player : Player

func _ready() -> void:
	assert(biomat_resource)
	assert(coll_shape and sprite and raycast)
	assert(state_machine and state_dead)


func toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)


func take_damage(amount: int):
	#stats.adjust_hp(- amount)
	state_machine.transition_to(state_dead)


func add_additional_force(force: Vector2):
	_additional_forces.append(force)


func apply_additional_forces() -> Vector2:
	var summary_force := Vector2.ZERO
	for force in _additional_forces:
		summary_force += force
	return summary_force


func remove_oldest_additional_force():
	if not _additional_forces.is_empty():
		_additional_forces.remove_at(0)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		_player = body
		state_machine.transition_to(state_following)
