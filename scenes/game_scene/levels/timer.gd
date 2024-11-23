extends Timer

var _enemies_depleted := false


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if not _enemies_depleted and get_tree().get_node_count_in_group("enemy") == 0:
		_enemies_depleted = true
		self.wait_time = 20 # sec


func _on_timeout() -> void:
	Global.level_loader.force_level = 1
	Global.level_loader.load_level()
