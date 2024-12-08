class_name BlasterProjectile
extends Area2D

const BLASTER_IMPACT_SOUND := "{3fd3a43b-5633-475f-afe2-d739591b11d0}"

@export var speed: float = 1000
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: Sprite2D
var direction: Vector2
var damage: int


static func create(damage: int, start_position: Vector2, direction: Vector2, color := Color.WHITE) -> BlasterProjectile:
	var projectile := Preloader.blaster_projectile.instantiate() as BlasterProjectile
	assert(projectile and direction.is_normalized())
	projectile.damage = damage
	projectile.position = start_position
	projectile.direction = direction
	projectile.modulate = color
	return projectile


func _ready() -> void:
	self.rotate(direction.angle())
	self.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					Global.play_fmod_sound(BLASTER_IMPACT_SOUND)
					body.take_damage(damage)
					self.queue_free()
				elif body is TileMapLayer or body is StaticBody2D:
					self.queue_free()
	)


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta


func _on_timer_timeout() -> void:
	queue_free()
