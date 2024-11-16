class_name RootAbility
extends Area2D

const GRAVITY_DURATION := 1.0
const GRAVITY_STRENGTH := 200.0

const ROOT_DURATION := 1.0
const IN_ROOT_SPEED := 5.0

@export_group("Required Children")
@export var coll_shape: CollisionShape2D

var spawn_position: Vector2
var _affected_enemies: Array[Enemy] = []


static func create(spawn_position: Vector2) -> RootAbility:
	var root_ability := Preloader.root_ability.instantiate() as RootAbility
	assert(root_ability)
	root_ability.spawn_position = spawn_position
	return root_ability


func _ready() -> void:
	assert(coll_shape)
	self.position = spawn_position
	
	self.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					_affected_enemies.append(body)
	)
	await Global.create_timer(0.1)
	
	for enemy in _affected_enemies:
		var direction := (self.position - enemy.position).normalized()
		var force := direction * GRAVITY_STRENGTH
		enemy.velocity += force
	
	await Global.create_timer(GRAVITY_DURATION)
	
	for enemy in _affected_enemies:
		enemy.velocity = Vector2.ZERO
		enemy.current_speed = IN_ROOT_SPEED
	
	await Global.create_timer(ROOT_DURATION)
	
	for enemy in _affected_enemies:
		enemy.current_speed = enemy.speed
	
	self.queue_free()
