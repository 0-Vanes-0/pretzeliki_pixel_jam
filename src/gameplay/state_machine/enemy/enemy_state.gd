class_name EnemyState
extends State

var enemy: Enemy


func _ready():
	await get_parent().ready
	enemy = state_machine.get_parent() as Enemy
	assert(enemy != null)
