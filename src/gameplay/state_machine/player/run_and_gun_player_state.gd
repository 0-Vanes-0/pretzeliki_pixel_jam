class_name RunAndGunPlayerState
extends PlayerState

const GUNSHOT_SOUND := "{20de73e4-98d8-4a26-9a37-f3490550498d}"
const DASH_SOUND := "{5ac49b05-6976-4ec8-9418-7e759066d149}"

const GRENADE_RELOAD_TIME := 2.0
const DASH_DURATION := 0.1
const DASH_STRENGTH := 5
const ONE_BLASTER_RELOAD_TIME := 0.2

var _shooter_timer := 0.0
var _grenade_timer := 0.0
var _dash_reload_timer := 0.0
var _stun_reload_timer := 0.0
var _blaster_reload_timer := 0.0


func enter():
	player.toggle_collision(true)
	_shooter_timer = player.shoot_rate_time
	_grenade_timer = GRENADE_RELOAD_TIME
	_dash_reload_timer = player.stats.dash_reload_time
	_stun_reload_timer = player.stats.stun_reload_time
	_blaster_reload_timer = ONE_BLASTER_RELOAD_TIME * player.stats.max_ammo
	#aim.activate() ??


func update(delta: float):
	super(delta)
	if player.current_look_direction.x != 0:
		var scale_x := player.sprite.scale.y * signf(player.current_look_direction.x)
		player.sprite.scale = Vector2(scale_x, player.sprite.scale.y)
	
	if player.velocity.length_squared() > 10:
		player.animate("run")
	else:
		player.animate("idle")
	
	player.weapon_pivot.rotation = Vector2(absf(player.current_look_direction.x), player.current_look_direction.y).angle()
	
	player.hands.visible = Global.suit_state == "ship_naked"
	player.weapon.visible = not Global.suit_state == "ship_naked"


func physics_update(delta: float):
	super(delta)
	
	_shooter_timer += delta
	_grenade_timer += delta
	_dash_reload_timer += delta
	_stun_reload_timer += delta
	_blaster_reload_timer += delta
	
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_direction:
		player.velocity = player.velocity.lerp(move_direction * player.stats.speed, 0.25)
	else:
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.25)
	player.move_and_slide()
	
	if Input.is_action_pressed("shoot") and player.stats.current_ammo > 0 and _shooter_timer >= player.shoot_rate_time and _blaster_reload_timer >= ONE_BLASTER_RELOAD_TIME * player.stats.max_ammo:
		var start_position := player.position + player.get_weapon_gunpoint()
		var direction := (player.current_look_direction - player.get_weapon_gunpoint()).normalized()
		var blaster_pro := BlasterProjectile.create(player.stats.current_blaster_damage, start_position, direction, Color.CRIMSON)
		player.add_sibling(blaster_pro)
		Global.play_sound(GUNSHOT_SOUND)
		_shooter_timer = 0.0
		player.stats.adjust_ammo(-1)
	
	if Input.is_action_pressed("grenade") and player.stats.current_grenades > 0 and _grenade_timer >= GRENADE_RELOAD_TIME:
		var start_position := player.position + player.get_weapon_gunpoint()
		var direction := (player.current_look_direction - player.get_weapon_gunpoint()).normalized()
		var grenade := Grenade.create(player.stats.current_grenade_damage, start_position, direction)
		player.add_sibling(grenade)
		_grenade_timer = 0.0
		player.stats.adjust_grenades(-1)
	
	if player.has_dash_ability() and Input.is_action_pressed("dash") and _dash_reload_timer >= player.stats.dash_reload_time:
		_dash() # <-- Calling async function here
		Global.play_sound(DASH_SOUND)
		_dash_reload_timer = 0.0
		player.stats.did_dash.emit()
	
	if player.has_stun_ability() and Input.is_action_pressed("stun_ability") and _stun_reload_timer >= player.stats.stun_reload_time:
		var spawn_position := player.position + player.current_look_direction
		var stun_ability := StunAbility.create(spawn_position)
		player.add_sibling(stun_ability)
		_stun_reload_timer = 0.0
		player.stats.did_stun.emit()


func handle_input(event: InputEvent):
	if event.is_action_pressed("reload_blaster") and player.stats.current_ammo < player.stats.max_ammo and _blaster_reload_timer >= ONE_BLASTER_RELOAD_TIME * player.stats.max_ammo:
		_reload()


func exit():
	pass


func _dash():
	var original_speed := player.stats.speed
	player.stats.speed *= DASH_STRENGTH
	await Global.create_timer(DASH_DURATION)
	player.stats.speed = original_speed


func _reload():
#	Global.play_sound("")
	_blaster_reload_timer = 0.0
	var ammo_delta := player.stats.max_ammo - player.stats.current_ammo
	for i in ammo_delta:
		player.stats.adjust_ammo(1)
		await Global.create_timer(ONE_BLASTER_RELOAD_TIME)
	_blaster_reload_timer = ONE_BLASTER_RELOAD_TIME * player.stats.max_ammo
