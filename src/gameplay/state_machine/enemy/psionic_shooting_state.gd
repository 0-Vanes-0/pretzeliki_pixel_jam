class_name PsionicShootingState
extends EnemyState


@export var _projectile : PackedScene

@export var shoot_cooldown : float = 1

@onready var attack_timer: Timer = $AttackTimer
@onready var player_distance_timer: Timer = $PlayerDistanceTimer

func enter():
	attack_timer.wait_time = shoot_cooldown
	attack_timer.start()
	player_distance_timer.start()
	attack()


func exit():
	attack_timer.stop()
	player_distance_timer.stop()
	# TODO stop attack animation (if _on_player_distance_timer_timeout does transition)


func attack():
	var projectile : PsionicProjectile = _projectile.instantiate()
	projectile.global_position = enemy.global_position
	projectile.direction = enemy.global_position.direction_to(enemy._player.global_position)
	
	enemy.get_parent().add_child(projectile)

func _on_attack_timer_timeout() -> void:
	attack()


func _on_player_distance_timer_timeout() -> void:
	var distance : float = enemy._player.global_position.distance_squared_to(enemy.global_position)
	if distance > enemy.nav_agent.target_desired_distance ** 2:
		enemy.state_machine.transition_to(enemy.state_following)
	
