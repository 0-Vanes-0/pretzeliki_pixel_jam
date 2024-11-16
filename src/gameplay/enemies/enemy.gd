class_name Enemy
extends CharacterBody2D

signal died(biomat_resource: BioMatResource, position: Vector2)

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var speed: float = 200.0
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


func _ready() -> void:
	assert(biomat_resource)
	assert(coll_shape and sprite and raycast)
	assert(state_machine and state_dead)


func toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)


func take_damage(amount: int):
	#stats.adjust_hp(- amount)
	state_machine.transition_to(state_dead)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		state_machine.transition_to(state_dead)
	
