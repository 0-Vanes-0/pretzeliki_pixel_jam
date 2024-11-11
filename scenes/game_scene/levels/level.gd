class_name Level
extends Node2D

@export var player: Player
@export var main_camera: PhantomCamera2D
@export var aim: Aim


func _ready() -> void:
	assert(player and main_camera and aim)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func _physics_process(delta: float) -> void:
	player.current_look_direction = aim.get_direction()
	main_camera.position = player.position + aim.get_direction() / 2
	
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second()) + " fps"
