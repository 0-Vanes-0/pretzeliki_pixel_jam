class_name Grenade
extends Area2D

const MAX_DISTANCE := 128
const BLOW_UP_EXIST_TIME := 0.5

@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D

var damage: int


static func create(damage: int, direction: Vector2) -> Grenade:
	var grenade := Preloader.grenade.instantiate() as Grenade
	assert(grenade)
	grenade.damage = damage
	return grenade


func _ready() -> void:
	assert(coll_shape)
	sprite.play("fly")
	
	self.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					body.take_damage(damage)
	)
	
	# Как-то полететь???
	var tween := create_tween()
	tween.tween_callback(
			func():
				_turn_on_collision()
				sprite.play("blow_up")
	)
	tween.tween_interval(BLOW_UP_EXIST_TIME)
	tween.tween_callback(self.queue_free)


func _turn_on_collision():
	coll_shape.set_deferred("disabled", false)
