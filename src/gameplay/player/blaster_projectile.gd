class_name BlasterProjectile
extends Area2D

@export var speed: float = 1000
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: Sprite2D
var direction: Vector2

static func create(start_position: Vector2, direction: Vector2, color := Color.WHITE) -> BlasterProjectile:
	var projectile := Preloader.blaster_projectile.instantiate() as BlasterProjectile
	assert(direction.is_normalized())
	projectile.position = start_position
	projectile.direction = direction
	projectile.modulate = color
	return projectile


func _ready() -> void:
	self.rotate(direction.angle())
	self.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					# body.take_damage()
					self.queue_free()
				elif body is StaticBody2D:
					self.queue_free()
	)


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
