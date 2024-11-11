class_name PauseMenuController
extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var pause_menu_packed: PackedScene
@export var pause_menu_layer: CanvasLayer


func _ready() -> void:
	assert(pause_menu_packed and pause_menu_layer)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		var current_menu := pause_menu_packed.instantiate() as PauseMenu
		assert(current_menu)
		current_menu.pauses_game = true
		pause_menu_layer.add_child(current_menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
