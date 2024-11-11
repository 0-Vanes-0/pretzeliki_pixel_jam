class_name Player
extends CharacterBody2D

const Animations := {
	IDLE = "idle",
	RUN = "run",
	DIE = "die",
}

@export var speed: float = 200.0
@export_group("Required Children")
@export var sprite: AnimatedSprite2D
var current_look_direction := Vector2.RIGHT


func _ready() -> void:
	assert(sprite)
