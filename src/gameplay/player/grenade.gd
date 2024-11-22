class_name Grenade
extends Area2D

const GRENADE_LAUNCH_SOUND := "{4498b93e-8ec4-489c-ad11-3d8f8d3c14c4}"
const GRENADE_EXPLOSION_SOUND := "{8f2d0efe-5627-40b7-bd2f-1ae8a9fb65c4}"

const MAX_DISTANCE := 256
const BLOW_UP_EXIST_TIME := 0.4
const SPEED := 750

@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var contact_area: Area2D
@export var contact_area_coll_shape: CollisionShape2D

var damage: int
var start_position: Vector2
var direction: Vector2
var _distance_counter: float


static func create(damage: int, start_position: Vector2, direction: Vector2) -> Grenade:
	var grenade := Preloader.grenade.instantiate() as Grenade
	assert(grenade)
	grenade.damage = damage
	grenade.start_position = start_position
	grenade.direction = direction
	return grenade


func _ready() -> void:
	assert(coll_shape and sprite and contact_area and contact_area_coll_shape)
	self.position = start_position
	sprite.play("fly")
	sprite.rotate(direction.angle())
	
	Global.play_sound(GRENADE_LAUNCH_SOUND)
	
	contact_area.body_entered.connect(
			func(body: Node2D):
				# Don't care what body it is
				_blow_up()
	)
	self.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					body.take_damage(damage)
				elif body is Player:
					body.take_damage(damage)
	)


func _physics_process(delta: float) -> void:
	self.position += direction * SPEED * delta
	_distance_counter += SPEED * delta
	if _distance_counter >= MAX_DISTANCE:
		_blow_up()


func _blow_up():
	Global.play_sound(GRENADE_EXPLOSION_SOUND)
	
	direction = Vector2.ZERO
	_turn_off_contact_collision()
	sprite.rotation = 0
	sprite.play("blow_up")
	_turn_on_blow_collision()
	await Global.create_timer(BLOW_UP_EXIST_TIME)
	self.queue_free()


func _turn_on_blow_collision():
	coll_shape.set_deferred("disabled", false)


func _turn_off_contact_collision():
	contact_area_coll_shape.set_deferred("disabled", true)
