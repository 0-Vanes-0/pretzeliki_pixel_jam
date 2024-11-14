class_name RoamEnemyState
extends EnemyState

@export var raycast_distance : float = 50

@onready var roam_timer: Timer = $RoamTimer

var _direction: Vector2
var _walking = true

func enter():
	roam_timer.start()
	enemy.toggle_collision(true)


func update(delta: float):
	super(delta)


func physics_update(delta: float):
	super(delta)
	if _walking:
		if enemy.raycast.is_colliding():
			roam_timer.stop()
			_on_roam_timer_timeout()
			roam_timer.start()
		enemy.velocity = _direction * delta * enemy.speed
		# FIXME add rotation
		#rotateToDirection(delta, _direction)
		enemy.move_and_slide()


func exit():
	pass


func _on_roam_timer_timeout() -> void:
	enemy.anim.play("walk")
	var ray = enemy.raycast
	ray.target_position = Vector2(randi_range(-100,100),randi_range(-100,100)).normalized() * 100
	if !ray.is_colliding():
		_direction = ray.target_position.normalized()
	else:
		var x = ray.target_position.x
		var y = ray.target_position.y
		for i in range(12): # ищем свободную точку
			var a = PI / 6.0 * i
			var cs = cos(a)
			var sn = sin(a)
			var new_dir = Vector2(x*cs - y*sn, y*cs+x*sn)
			ray.target_position = ray.target_position.rotated(a)# new_dir #Vector2(randi_range(-100,100),randi_range(-100,100)).normalized() * 400
			await get_tree().create_timer(0.05).timeout
			if !ray.is_colliding():
				#ray.target_position = ray.target_position.normalized()
				_direction = ray.target_position.normalized()
				_walking = true
				#await anim.animation_finished
				#anim.play("walk")
				return
			#await get_tree().create_timer(0.01).timeout
		print(name + " failed to find a way out")
		_walking = false
		roam_timer.start()
		await enemy.anim.animation_finished
		enemy.anim.play("default")
