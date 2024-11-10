class_name PlayerState
extends State

var player: Player


func _ready():
	await get_parent().ready
	player = state_machine.get_parent() as Player
	assert(player != null)
