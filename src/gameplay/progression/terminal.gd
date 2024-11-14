class_name Terminal
extends StaticBody2D

@export var interactable: InteractableComponent
@export var p_cam: PhantomCamera2D
var _is_being_used := false


func _ready() -> void:
	assert(interactable and p_cam)
	
	interactable.interacted.connect(
			func(player: Player):
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
