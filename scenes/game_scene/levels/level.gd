class_name Level
extends Node2D

@export_group("Required Children")
@export var enemies: EnemyCollectionNode
@export var biomats: BioMatCollectionNode
@export var player: Player
@export var main_camera: PhantomCamera2D
@export var aim: Aim
@export var player_interface: PlayerInterface
@export var terminal_interface: TerminalInterface


func _ready() -> void:
	assert(enemies and biomats and player and main_camera and aim and player_interface and terminal_interface)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	player.entered_terminal.connect(
			func():
				var tween := create_tween()
				tween.tween_property(player_interface, "modulate:a", 0.0, 0.5)
				tween.tween_callback( func():
						player_interface.hide()
						terminal_interface.appear()
				)
	)
	player.exited_terminal.connect(
			func():
				terminal_interface.disappear()
				var tween := create_tween()
				tween.tween_interval(1.0)
				tween.tween_callback(player_interface.show)
				tween.tween_property(player_interface, "modulate:a", 1.0, 0.5)
	)
	
	for enemy in enemies.get_array():
		enemy.died.connect(_on_enemy_died, CONNECT_ONE_SHOT)


func _physics_process(delta: float) -> void:
	player.current_look_direction = aim.get_direction()
	main_camera.position = lerp(main_camera.position, player.position + aim.get_direction() / 2, .3)
	
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second()) + " fps"


func _on_enemy_died(biomat_resource: BioMatResource, position: Vector2):
	var biomat := BioMat.create(biomat_resource)
	biomat.position = position
	biomats.add_child(biomat)
