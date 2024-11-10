class_name Aim
extends AnimatedSprite2D

@export var _player: Player


func _physics_process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position()
