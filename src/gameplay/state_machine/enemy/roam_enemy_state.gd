class_name RoamEnemyState
extends EnemyState

@export var raycast_distance : float = 50

@onready var roam_timer: Timer = $RoamTimer
@onready var idle_timer: Timer = $IdleTimer

var _direction: Vector2
var _walking := true

func enter():
	roam_timer.start()
	enemy.toggle_collision(true)
	enemy.current_speed = enemy.speed


func update(delta: float):
	super(delta)
	if _walking:
		enemy.animate("run")
	else:
		enemy.animate("idle")


func physics_update(delta: float):
	super(delta)
	if _walking:
		if enemy.raycast.is_colliding():
			roam_timer.stop()
			_on_roam_timer_timeout()
			roam_timer.start()
		enemy.velocity = _direction * enemy.current_speed
		# FIXME add rotation
		#rotateToDirection(delta, _direction)
		enemy.move_and_slide()


func exit():
	roam_timer.stop()
	idle_timer.stop()


func _on_roam_timer_timeout(from_timer = true) -> void:
	if from_timer and randi() % 3 == 0:
		_walking = false
		enemy.animate("idle")
		roam_timer.stop()
		idle_timer.wait_time = randf_range(1.8, 2.5)
		idle_timer.start()
		return
	# TODO randomize roam_timer's wait_time
	enemy.animate("run")
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
			var new_dir = Vector2(x*cs - y*sn, y*cs + x*sn)
			ray.target_position = ray.target_position.rotated(a)# new_dir #Vector2(randi_range(-100,100),randi_range(-100,100)).normalized() * 400
			await Global.create_timer(0.05)
			if !ray.is_colliding():
				#ray.target_position = ray.target_position.normalized()
				_direction = ray.target_position.normalized()
				_walking = true
				#await anim.animation_finished
				#anim.play("walk")
				return
			#await Global.create_timer(0.01)
		print(name + " failed to find a way out")
		_walking = false
		roam_timer.start()
		await enemy.sprite.animation_finished
		enemy.animate("idle")


func _on_idle_timer_timeout() -> void:
	_walking = true
	#enemy.anim.play("idle") dont need, walk is set in in _on_roam_timer_timeout 
	_on_roam_timer_timeout(false)
	roam_timer.start()
	#idle_timer.stop() dont need, it's oneshot
