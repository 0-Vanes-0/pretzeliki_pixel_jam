class_name Enemy
extends CharacterBody2D

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var speed: float = 200.0
@export var biomats: Array[BioMat] = []
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D


func _ready() -> void:
	assert(coll_shape and sprite)


func toggle_collision(enable: bool):
	coll_shape.disabled = not enable
