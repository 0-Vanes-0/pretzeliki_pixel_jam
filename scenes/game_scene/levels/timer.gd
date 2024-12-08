extends Timer

var _enemies_depleted := false


func _ready() -> void:
	Global.play_voice("simulation_start")


func _physics_process(delta: float) -> void:
	if not _enemies_depleted and get_tree().get_node_count_in_group("enemy") == 0:
		_enemies_depleted = true
		self.start(20) # sec
		print("no enemies")


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0:
			_on_timeout()


func _on_timeout() -> void:
	Global.play_voice("simulation_end")
	await Global.create_timer(Preloader.voice_simulation_end.get_length())
	Global.suit_state = "ship_naked" 
	Global.level_loader.force_level = 1
	Global.level_loader.load_level()
	ProjectMusicController.play_music("battle")
