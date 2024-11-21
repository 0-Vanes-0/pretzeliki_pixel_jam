class_name PlayerInterface
extends MarginContainer

@export_group("Required Children")
@export var hp_bar: TextureProgressBar
@export var hp_label: Label
@export var ammo_bar: TextureProgressBar
@export var ammo_label: Label
@export var grenade_label: Label
@export var dash_bar: TextureProgressBar
@export var stun_bar: TextureProgressBar
@export var armor_bar: TextureProgressBar

var _player: Player


func _ready() -> void:
	assert(hp_bar and hp_label and ammo_bar and ammo_label and grenade_label and dash_bar and stun_bar and armor_bar)
	_player = get_tree().get_first_node_in_group("player") as Player
	assert(_player)
	
	hp_bar.min_value = 0
	set_hp(_player.stats.max_hp, _player.stats.max_hp)
	
	ammo_bar.min_value = 0
	set_ammo(_player.stats.max_ammo, _player.stats.max_ammo)
	set_grenades(_player.stats.max_grenades)
	
	dash_bar.min_value = 0
	dash_bar.max_value = _player.stats.dash_reload_time
	dash_bar.value = dash_bar.max_value
	
	stun_bar.min_value = 0
	stun_bar.max_value = _player.stats.stun_reload_time
	stun_bar.value = stun_bar.max_value
	
	armor_bar.min_value = 0
	set_armor(_player.stats.max_armor, _player.stats.max_armor)
	
	_player.stats.health_changed.connect(
			func(value: int, max_value: int):
				set_hp(value, max_value)
	)
	_player.stats.ammo_changed.connect(
			func(value: int, max_value: int):
				set_ammo(value, max_value)
	)
	_player.stats.grenades_changed.connect(
			func(value: int, max_value: int):
				set_grenades(value)
	)
	_player.stats.armor_changed.connect(
			func(value: int, max_value: int):
				set_armor(value, max_value)
	)


func set_hp(value: int, max_value: int = 0):
	if max_value > 0:
		hp_bar.max_value = max_value
	hp_bar.value = value
	hp_label.text = str(hp_bar.value) + "/" + str(hp_bar.max_value)


func set_ammo(value: int, max_value: int = 0):
	if max_value > 0:
		ammo_bar.max_value = max_value
	ammo_bar.value = value
	ammo_label.text = str(ammo_bar.value) + "/" + str(ammo_bar.max_value)


func set_grenades(value: int):
	grenade_label.text = str(value)


func set_armor(value: int, max_value: int = 0):
	if max_value > 0:
		armor_bar.max_value = max_value
	armor_bar.value = value
