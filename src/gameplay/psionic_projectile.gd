class_name PsionicProjectile
extends Area2D

@export var speed: float = 1000
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: Sprite2D

var direction: Vector2

func _ready() -> void:
	self.rotate(direction.angle())


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
		self.queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		self.queue_free()


func _on_timer_timeout() -> void:
	queue_free()
