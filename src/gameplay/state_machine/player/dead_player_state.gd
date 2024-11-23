class_name DeadPlayerState
extends PlayerState


func enter():
	player.toggle_collision(false)
	player.animate("die")


func update(delta: float):
	super(delta)


func physics_update(delta: float):
	super(delta)


func exit():
	pass
