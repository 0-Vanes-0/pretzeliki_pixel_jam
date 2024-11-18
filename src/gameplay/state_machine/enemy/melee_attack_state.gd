class_name MeleeAttackState
extends EnemyState



@export var attack_damage : float = 1
@export var attack_cooldown : float = 1.3

@onready var player_distance_timer: Timer = $PlayerDistanceTimer
@onready var attack_timer: Timer = $AttackTimer
# фиксит баг когда игрок отбегает понемногу, удар происходит очень часто
@onready var can_attack_timer: Timer = $CanAttackTimer 

var _can_attack : bool = true

func _ready() -> void:
	super()
	attack_timer.wait_time = attack_cooldown
	can_attack_timer.wait_time = attack_cooldown

func enter():
	attack_timer.start()
	player_distance_timer.start()
	attack()


func exit():
	attack_timer.stop()
	player_distance_timer.stop()


func attack():
	if not _can_attack:
		return
	
	print("MELEE ATTACK")
	# if player is not nearby, _on_player_distance_timer_timeout will do transition
	enemy._player.take_damage(attack_damage)
	_can_attack = false
	can_attack_timer.start()


func _on_player_distance_timer_timeout() -> void:
	var distance : float = enemy._player.global_position.distance_squared_to(enemy.global_position)
	if distance > enemy.nav_agent.target_desired_distance ** 2:
		enemy.state_machine.transition_to(enemy.state_following)


func _on_attack_timer_timeout() -> void:
	attack()


func _on_can_attack_timer_timeout() -> void:
	_can_attack = true
