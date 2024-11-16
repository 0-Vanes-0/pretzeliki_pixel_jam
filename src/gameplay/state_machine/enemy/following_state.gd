class_name FollowingState
extends EnemyState

@export var desired_next_state : EnemyState
@export var nav_agent : NavigationAgent2D

var is_nav : bool = false # because check agent property "nav_agent.is_navigation_finished()" doesnt work

func enter():
	is_nav = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_nav:
		return
	
	var dir = enemy.global_position.direction_to(nav_agent.get_next_path_position())
	var ang = dir.angle()
	# TODO enemy rotation
	#body.rotation = lerp_angle(enemy..rotation, ang, 0.2) 
	var vel = dir * enemy.speed * delta
	nav_agent.set_velocity(vel)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	enemy.velocity = safe_velocity
	nav_agent.is_target_reachable() # i dunno but this magic makes it work
	#print(global_position, " ", nav_agent.target_position, " ", velocity)
	enemy.move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	enemy.state_machine.transition_to(desired_next_state)
	is_nav = false
