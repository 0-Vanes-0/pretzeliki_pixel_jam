class_name TerminalPlayerState
extends PlayerState


func enter():
	player.entered_terminal.emit()
	player.toggle_collision(true)
	player.velocity = Vector2.ZERO
	player.sprite.play(player.Animations.IDLE)
	if player.current_look_direction.x != 0:
		var scale_x := player.sprite.scale.y * signf(player.current_look_direction.x)
		player.sprite.scale = Vector2(scale_x, player.sprite.scale.y)


func update(delta: float):
	super(delta)


func physics_update(delta: float):
	super(delta)


func exit():
	player.exited_terminal.emit()
