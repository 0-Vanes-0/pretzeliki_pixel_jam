## This is global script which stores global variables and helps with some global processes
## like pausing game, switching scenes, getting player data etc.
extends Node

var SCREEN_WIDTH: int; var SCREEN_HEIGHT: int; var RATIO := ":"
var DEFAULT_DATA := {
	
}

var settings := {
	
}
var player_data := {
	
}

func _ready() -> void:
	setup()


func setup():
	SCREEN_WIDTH = int(get_viewport().get_visible_rect().size.x)
	SCREEN_HEIGHT = int(get_viewport().get_visible_rect().size.y)
	var gcd := _gcd(SCREEN_WIDTH, SCREEN_HEIGHT)
	RATIO = str(SCREEN_WIDTH / gcd) + RATIO + str(SCREEN_HEIGHT / gcd)
	print_debug("\t", "SCREEN_WIDTH=", SCREEN_WIDTH, ", SCREEN_HEIGHT=", SCREEN_HEIGHT, ", RATIO=", RATIO)


func create_timer(time: float):
	await get_tree().create_timer(time, false, true).timeout


# NOD
func _gcd(a: int, b: int) -> int:
	while a > 0 and b > 0:
		if a > b:
			a %= b
		else:
			b %= a
	return a + b
