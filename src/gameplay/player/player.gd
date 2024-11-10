class_name Player
extends CharacterBody2D

const SPEED := 10000.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		self.velocity = lerp(self.velocity, direction * SPEED * delta, 0.25)
	else:
		self.velocity = lerp(self.velocity, Vector2.ZERO, 0.25)
	
	self.move_and_slide()
