class_name RunAndGunPlayerState
extends PlayerState


func enter():
	pass


func update(delta: float):
	super(delta)
	if player.current_look_direction.x != 0:
		var scale_x := player.sprite.scale.y * signf(player.current_look_direction.x)
		player.sprite.scale = Vector2(scale_x, player.sprite.scale.y)


func physics_update(delta: float):
	super(delta)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		player.velocity = player.velocity.lerp(direction * player.speed, 0.25)
	else:
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.25)
	
	if player.velocity.length_squared() > 10:
		player.sprite.play(player.Animations.RUN)
	else:
		player.sprite.play(player.Animations.IDLE)
	
	player.move_and_slide()


func exit():
	pass
