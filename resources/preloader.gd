## Singleton for converting resources paths to variables.
extends Node

@export_group("Screens", "screen_")

@export_group("Game Objects")
@export var blaster_projectile: PackedScene
@export var biomat: PackedScene
@export var grenade: PackedScene
@export var stun_ability: PackedScene

@export_group("Voice", "voice_")
@export var voice_death: AudioStream
@export var voice_goal_reached: AudioStream
@export var voice_level_near_end: AudioStream
@export var voice_near_death: AudioStream
@export var voice_new_mutation: AudioStream
@export var voice_no_grenades: AudioStream
@export var voice_permanent_biomat: AudioStream
@export var voice_putting_biomat: AudioStream
@export var voice_ship_start: AudioStream
@export var voice_simulation_end: AudioStream
@export var voice_simulation_start: AudioStream


func _ready() -> void:
	assert(blaster_projectile and biomat and grenade and stun_ability)
