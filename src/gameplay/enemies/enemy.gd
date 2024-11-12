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


func _ready() -> void:
	assert(biomat_resource)
	assert(coll_shape and sprite and raycast)


func toggle_collision(enable: bool):
	coll_shape.disabled = not enable


func emit_died():
	died.emit(biomat_resource, self.position)
