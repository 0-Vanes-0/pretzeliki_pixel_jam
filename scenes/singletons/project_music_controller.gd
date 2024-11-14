extends MusicController

@export var emitter: FmodEventEmitter2D


func _ready() -> void:
	assert(emitter)


func play_fmod(mode: String):
	var modes := {
		"main_menu": {
			"in_game": 0,
			"intensity": 0,
		},
		"simulation": {
			"in_game": 1,
			"intensity": 0,
		},
		"battle": {
			"in_game": 2,
			"intensity": 0,
		},
		"battle_horde": {
			"in_game": 2,
			"intensity": 1,
		},
	}
	assert(mode in modes.keys())
	
	emitter["event_parameter/In Game/value"] = modes[mode]["in_game"]
	emitter["event_parameter/Intensity/value"] = modes[mode]["intensity"]
	emitter.play()
