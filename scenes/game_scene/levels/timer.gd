extends Timer

var _enemies_depleted := false


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if not _enemies_depleted and get_tree().get_node_count_in_group("enemy") == 0:
		_enemies_depleted = true
		self.start(20) # sec
		print("no enemies")


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0:
			Global.suit_state = "ship_naked"
			Global.level_loader.force_level = 1
			Global.level_loader.load_level()
			ProjectMusicController.play_music("battle")


func _on_timeout() -> void:
	Global.suit_state = "ship_naked" 
	Global.level_loader.force_level = 1
	Global.level_loader.load_level()
	ProjectMusicController.play_music("battle")
