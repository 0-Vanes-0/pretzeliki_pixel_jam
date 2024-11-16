class_name FollowingState
extends EnemyState

@export var speed_coeff : float = 1.5
@export var desired_next_state : EnemyState

var nav_agent : NavigationAgent2D

@export var debug_label : Label

var is_nav : bool = false # because check agent property "nav_agent.is_navigation_finished()" doesnt work

func _ready() -> void:
	super()
	if desired_next_state and desired_next_state not in connections:
		connections.append(desired_next_state)

func enter():
	is_nav = true
	nav_agent = enemy.nav_agent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float) -> void:
	#debug_label.text = str(enemy.state_machine.get_state()) + str(is_nav) + str(enemy.velocity)
	if !is_nav:
		return
	
	# TODO можно менять таргет пореже для оптимизации
	nav_agent.target_position = enemy._player.global_position
	var dir = enemy.global_position.direction_to(nav_agent.get_next_path_position())
	var ang = dir.angle()
	# TODO enemy rotation
	#body.rotation = lerp_angle(enemy..rotation, ang, 0.2) 
	var vel = dir * enemy.speed * speed_coeff * delta
	nav_agent.set_velocity(vel)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if !is_nav:
		return
	#prints(self, safe_velocity)
	enemy.velocity = safe_velocity
	nav_agent.is_target_reachable() # i dunno but this magic makes it work
	#print(global_position, " ", nav_agent.target_position, " ", velocity)
	enemy.move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	prints(self, "REACHED")
	enemy.state_machine.transition_to(desired_next_state)
	is_nav = false
