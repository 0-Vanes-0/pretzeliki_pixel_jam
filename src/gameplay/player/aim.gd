class_name Aim
extends AnimatedSprite2D

@export var _player: Player
var joystick_sensivity: float


func _ready() -> void:
	joystick_sensivity = Config.get_config("InputSettings", "MouseSensitivity", 100.0)


func _physics_process(delta: float) -> void:
	if Global.input_mode == Global.InputModes.KEYBOARD:
		self.position = get_viewport().get_mouse_position()
	elif Global.input_mode == Global.InputModes.JOYPAD:
		var joystick_direction := Input.get_vector("look_left", "look_right", "look_up", "look_down", 0.1)
		if joystick_direction:
			self.position += joystick_direction * joystick_sensivity * delta
			self.position = self.position.clamp(Vector2(0,0), Vector2(Global.SCREEN_WIDTH, Global.SCREEN_HEIGHT))


func get_direction() -> Vector2:
	return (self.position - get_viewport_rect().size / 2) * 2
