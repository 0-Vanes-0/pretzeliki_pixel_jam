class_name RunAndGunPlayerState
extends PlayerState


func enter():
	pass


func update(delta: float):
	super(delta)


func physics_update(delta: float):
	super(delta)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		player.velocity = player.velocity.lerp(direction * player.speed, 0.25)
	else:
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.25)
	
	player.move_and_slide()


func exit():
	pass
