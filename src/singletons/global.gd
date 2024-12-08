## This is global script which stores global variables and helps with some global processes
## like pausing game, switching scenes, getting player data etc.
extends Node

signal input_mode_changed(input_mode: InputModes)
signal suit_state_changed
signal audio_setting_changed

enum InputModes {
	KEYBOARD, JOYPAD
}
var SCREEN_WIDTH: int; var SCREEN_HEIGHT: int; var RATIO := ":"
var input_mode: InputModes = InputModes.KEYBOARD
var suit_state := "simulation" : # "simulation" / "ship_naked" / "ship"
	set(value):
		suit_state_changed.emit()
		suit_state = value
var level_loader: LevelListLoader


func _ready() -> void:
	setup()


func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouse) and input_mode != InputModes.KEYBOARD:
		input_mode = InputModes.KEYBOARD
		input_mode_changed.emit(input_mode)
	elif (event is InputEventJoypadButton or event is InputEventJoypadMotion) and input_mode != InputModes.JOYPAD:
		input_mode = InputModes.JOYPAD
		input_mode_changed.emit(input_mode)


func setup():
	SCREEN_WIDTH = int(get_viewport().get_visible_rect().size.x)
	SCREEN_HEIGHT = int(get_viewport().get_visible_rect().size.y)
	var gcd := _gcd(SCREEN_WIDTH, SCREEN_HEIGHT)
	RATIO = str(SCREEN_WIDTH / gcd) + RATIO + str(SCREEN_HEIGHT / gcd)
	print_debug("\t", "SCREEN_WIDTH=", SCREEN_WIDTH, ", SCREEN_HEIGHT=", SCREEN_HEIGHT, ", RATIO=", RATIO)


func create_timer(time: float):
	await get_tree().create_timer(time, false, true).timeout


func play_fmod_sound(guid: String, volume_multiplier := 1.0):
	var event_emitter := FmodEventEmitter2D.new()
	event_emitter.event_guid = guid
	event_emitter.autoplay = true
	event_emitter.stopped.connect(event_emitter.queue_free)
	
	var INITIAL_VOLUME := 12 # db
	event_emitter.volume = INITIAL_VOLUME * (get_volume_float(true) * volume_multiplier)
	
	add_child(event_emitter)


func play_voice(quote: String):
	var stream := Preloader.get("voice_" + quote) as AudioStream
	if stream:
		var asp := AudioStreamPlayer.new()
		asp.bus = "Sounds"
		asp.stream = stream
		asp.volume_db = 0 #linear_to_db(Global.get_volume_float(true))
		asp.finished.connect(asp.queue_free)
		self.add_child(asp)
		asp.play()


func get_volume_float(of_sound: bool) -> float:
	var master_volume := AppSettings.get_bus_volume(AudioServer.get_bus_index("Master"))
	var music_volume := AppSettings.get_bus_volume(AudioServer.get_bus_index("Music"))
	var sounds_volume := AppSettings.get_bus_volume(AudioServer.get_bus_index("Sounds"))
	return master_volume * (sounds_volume if of_sound else music_volume)

# NOD
func _gcd(a: int, b: int) -> int:
	while a > 0 and b > 0:
		if a > b:
			a %= b
		else:
			b %= a
	return a + b
