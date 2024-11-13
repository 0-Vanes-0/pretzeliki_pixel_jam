class_name RoamEnemyState
extends EnemyState

var _tween: Tween
var _direction: Vector2
var _distance: int


func enter():
	enemy.toggle_collision(true)
	_create_move_tween()


func update(delta: float):
	super(delta)
	if enemy.velocity.x != 0:
		var scale_x := enemy.sprite.scale.y * signf(enemy.velocity.x)
		enemy.sprite.scale = Vector2(scale_x, enemy.sprite.scale.y)


func physics_update(delta: float):
	super(delta)
	enemy.move_and_slide()


func exit():
	_tween.kill()


func _randomize_direction():
	_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	enemy.raycast.target_position = _direction * 128
	enemy.raycast.force_raycast_update()
	if enemy.raycast.is_colliding():
		_direction *= -1.0 # inverse


func _randomize_distance():
	_distance = randi_range(16, 128)


func _create_move_tween():
	_tween = create_tween()
	_tween.tween_callback(_randomize_distance)
	_tween.tween_callback(_randomize_direction)
	_tween.tween_property(
			enemy, "velocity",
			_direction * _distance,
			1.0
	).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	_tween.tween_interval(_distance / enemy.speed)
	_tween.tween_property(
			enemy, "velocity",
			Vector2.ZERO,
			1.0
	).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	_tween.finished.connect(_create_move_tween, CONNECT_ONE_SHOT)
