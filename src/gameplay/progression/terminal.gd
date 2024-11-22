class_name Terminal
extends StaticBody2D

@export_group("Required Children")
@export var enemy_check_area: Area2D
@export var interactable: InteractableComponent
@export var p_cam: PhantomCamera2D
@export var label: Label
var _is_being_used := false
var _enemy_counter := 0


func _ready() -> void:
	assert(enemy_check_area and interactable and p_cam and label)
	
	interactable.interacted.connect(
			func(player: Player):
				if _enemy_counter > 0:
					label.show()
					await Global.create_timer(2.0)
					label.hide()
				else:
					if not _is_being_used:
						player.current_look_direction = self.position - player.position
						player.state_machine.transition_to(player.state_terminal)
						p_cam.priority = 2
						_is_being_used = true
					else:
						player.state_machine.transition_to(player.state_run_and_gun)
						p_cam.priority = 0
						_is_being_used = false
	)
	
	enemy_check_area.body_entered.connect(
			func(body: Node2D):
				if body is Enemy:
					_enemy_counter += 1
	)
	enemy_check_area.body_exited.connect(
			func(body: Node2D):
				if body is Enemy:
					_enemy_counter -= 1
	)
	
