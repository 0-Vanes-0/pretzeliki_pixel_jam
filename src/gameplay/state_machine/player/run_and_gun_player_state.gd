class_name RunAndGunPlayerState
extends PlayerState

const GRENADE_RELOAD_TIME := 2.0

const DASH_DURATION := 0.1
const DASH_RELOAD_TIME := 4.0 # TODO: take from biomats
const DASH_STRENGTH := 5

const ROOT_RELOAD_TIME := 30.0

var _shooter_timer := 0.0
var _grenade_timer := 0.0
var _dash_reload_timer := 0.0
var _root_reload_timer := 0.0


func enter():
	player.toggle_collision(true)
	_shooter_timer = player.shoot_rate_time
	_grenade_timer = GRENADE_RELOAD_TIME
	_dash_reload_timer = DASH_RELOAD_TIME
	_root_reload_timer = ROOT_RELOAD_TIME
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
	_dash_reload_timer += delta
	_root_reload_timer += delta
	
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
		player.add_sibling(blaster_pro)
		_shooter_timer = 0.0
	
	if Input.is_action_pressed("grenade") and _grenade_timer >= GRENADE_RELOAD_TIME:
		var start_position := player.get_weapon_gunpoint()
		var direction := player.current_look_direction.normalized()
		var grenade := Grenade.create(10, start_position, direction) # TODO: add non-constant grenade damage
		player.add_sibling(grenade)
		_grenade_timer = 0.0
	
	if Input.is_action_pressed("dash") and _dash_reload_timer >= DASH_RELOAD_TIME:
		_dash() # <-- Calling async function here
		_dash_reload_timer = 0.0
	
	if Input.is_action_pressed("root_ability") and _root_reload_timer >= ROOT_RELOAD_TIME:
		var spawn_position := player.position + player.current_look_direction
		var root_ability := StunAbility.create(spawn_position)
		player.add_sibling(root_ability)
		_root_reload_timer = 0.0


func exit():
	pass


func _dash():
	var original_speed := player.stats.speed
	player.stats.speed *= DASH_STRENGTH
	await Global.create_timer(DASH_DURATION)
	player.stats.speed = original_speed
