class_name RunAndGunPlayerState
extends PlayerState

const GRENADE_DELAY := 2.0
var _shooter_timer := 0.0
var _grenade_timer := 0.0


func enter():
	player.toggle_collision(true)
	_shooter_timer = player.shoot_rate_time
	#aim.activate() ??


func update(delta: float):
	super(delta)
	if player.current_look_direction.x != 0:
		var scale_x := player.sprite.scale.y * signf(player.current_look_direction.x)
		player.sprite.scale = Vector2(scale_x, player.sprite.scale.y)


func physics_update(delta: float):
	super(delta)
	
	_shooter_timer += delta
	_grenade_timer += delta
	
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_direction:
		player.velocity = player.velocity.lerp(move_direction * player.stats.speed, 0.25)
	else:
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.25)
	player.move_and_slide()
	
	if player.velocity.length_squared() > 10:
		player.sprite.play(player.Animations.RUN)
	else:
		player.sprite.play(player.Animations.IDLE)
	
	if Input.is_action_pressed("shoot") and _shooter_timer >= player.shoot_rate_time:
		var start_position := player.get_weapon_gunpoint()
		var direction := player.current_look_direction.normalized() # TODO: direction is not accurate :/
		var blaster_pro := BlasterProjectile.create(start_position, direction, Color.CRIMSON)
		var parent := player.get_parent() as Node2D # $PlayerStuff
		parent.add_child(blaster_pro)
		_shooter_timer = 0.0
	
	if Input.is_action_pressed("grenade") and _grenade_timer >= GRENADE_DELAY:
		var start_position := player.get_weapon_gunpoint()
		var direction := player.current_look_direction.normalized()
		var grenade := Grenade.create(10, start_position, direction) # TODO: add non-constant grenade damage
		var parent := player.get_parent() as Node2D # $PlayerStuff
		parent.add_child(grenade)
		_grenade_timer = 0.0


func exit():
	pass
