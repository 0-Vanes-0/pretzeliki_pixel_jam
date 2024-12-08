## Code by Maaack
extends MainMenu

var animation_state_machine : AnimationNodeStateMachinePlayback


func play_game():
	GameLog.game_started()
	ProjectMusicController.play_music("simulation")
	super.play_game()


func intro_done():
	animation_state_machine.travel("OpenMainMenu")


func _is_in_intro():
	return animation_state_machine.get_current_node() == "Intro"


func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()


func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)


func _open_sub_menu(menu):
	super._open_sub_menu(menu)
	animation_state_machine.travel("OpenSubMenu")


func _close_sub_menu():
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")


func _input(event):
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	super._input(event)


func _ready():
	super._ready()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ProjectMusicController.play_music("main_menu")


func _on_play_button_mouse_entered() -> void:
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/PlayButton/FmodEventEmitter2D.volume = _get_volume()
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/PlayButton/FmodEventEmitter2D.play()


func _on_options_button_mouse_entered() -> void:
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/OptionsButton/FmodEventEmitter2D.volume = _get_volume()
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/OptionsButton/FmodEventEmitter2D.play()


func _on_credits_button_mouse_entered() -> void:
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/CreditsButton/FmodEventEmitter2D.volume = _get_volume()
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/CreditsButton/FmodEventEmitter2D.play()


func _on_exit_button_mouse_entered() -> void:
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/ExitButton/FmodEventEmitter2D.volume = _get_volume()
	$MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/ExitButton/FmodEventEmitter2D.play()


func _get_volume() -> float:
	var INITIAL_VOLUME := 12 # db
	return INITIAL_VOLUME * Global.get_volume_float(true)


func _on_exit_button_pressed():
	# TODO: Add some animation here?
	super._on_exit_button_pressed()
