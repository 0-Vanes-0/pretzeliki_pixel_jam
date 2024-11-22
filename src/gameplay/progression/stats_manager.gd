class_name StatsManager
extends Node

signal health_changed(value: int, max_value: int)
signal health_depleted
signal ammo_changed(value: int, max_value: int)
signal ammo_depleted
signal grenades_changed(value: int, max_value: int)
signal grenades_depleted
signal armor_changed(value: int, max_value: int)
signal armor_depleted
signal did_dash
signal did_stun

@export var max_hp: int = 100
@export var speed: float = 200.0
@export var max_ammo: int = 20
@export var max_grenades: int = 20
@export var blaster_damage: int = 2
@export var grenade_damage: int = 10
@export var biomats_temp := { # BioMatResource.BuffTypes: Array[BioMatResource]
	BioMatResource.BuffTypes.TUTORIAL: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.DASH: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.ROOT: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.ARMOR: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
}
@export var biomats_perm := { # BioMatResource.BuffTypes: Array[BioMatResource]
	BioMatResource.BuffTypes.TUTORIAL: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.DASH: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.ROOT: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
	BioMatResource.BuffTypes.ARMOR: Array([], TYPE_OBJECT, &"RefCounted", BioMatResource),
}

var dash_reload_time: float
var stun_reload_time: float
var max_armor: float

var current_armor: int
var current_hp: int
var current_speed: int
var current_ammo: int
var current_grenades: int
var current_blaster_damage: int
var current_grenade_damage: int


func _ready() -> void:
	dash_reload_time = 0.0
	stun_reload_time = 0.0
	max_armor = 0.0
	
	current_armor = max_armor
	current_hp = max_hp
	current_speed = speed
	current_ammo = max_ammo
	current_grenades = max_grenades
	current_blaster_damage = blaster_damage
	current_grenade_damage = grenade_damage
	_update_player_stats()


func add_biomat(biomat_resource: BioMatResource):
	var array: Array = biomats_temp[biomat_resource.buff_type]
	array.append(biomat_resource)
	_update_player_stats()


func adjust_health(value: int, is_from_biomat := false):
	var min_value: int = 0
	if is_from_biomat:
		min_value = 5
	
	current_hp = clampi(current_hp + value, min_value, max_hp)
	health_changed.emit(current_hp, max_hp)
	
	if current_hp == 0:
		health_depleted.emit()


func adjust_ammo(value: int):
	current_ammo = clampi(current_ammo + value, 0, max_ammo)
	ammo_changed.emit(current_ammo, max_ammo)
	if current_ammo == 0:
		ammo_depleted.emit()


func adjust_grenades(value: int):
	current_grenades = clampi(current_grenades + value, 0, max_grenades)
	grenades_changed.emit(current_grenades, max_grenades)
	if current_grenades == 0:
		grenades_depleted.emit()


func adjust_armor(value: int):
	current_armor = clampi(current_armor + value, 0, max_armor)
	armor_changed.emit(current_armor, max_armor)
	if current_armor == 0:
		armor_depleted.emit()


func _update_player_stats(is_on_terminal := false):
	for buff_type in biomats_temp.keys():
		var chunk: int = BioMatResource.BUFFS_CHUNKS.get(buff_type)
		var temp_array: Array = biomats_temp.get(buff_type)
		var perm_array: Array = biomats_perm[buff_type]
		if temp_array.size() >= chunk:
			for i in chunk:
				perm_array.append(temp_array.pop_back())
		
		for biomat in temp_array:
			current_hp += biomat.hp_buff
			current_speed += speed * biomat.speed_buff_percent / 100
	
	if is_on_terminal:
		var default_dash_reload_time: float = BioMatResource.BUFFS_DEFAULT_VALUES[BioMatResource.BuffTypes.DASH]
		dash_reload_time = default_dash_reload_time
		for biomat: BioMatResource in biomats_perm[BioMatResource.BuffTypes.DASH]:
			dash_reload_time += biomat.buff_value
		
		var default_stun_reload_time: float = BioMatResource.BUFFS_DEFAULT_VALUES[BioMatResource.BuffTypes.ROOT]
		stun_reload_time = default_stun_reload_time
		for biomat: BioMatResource in biomats_perm[BioMatResource.BuffTypes.ROOT]:
			stun_reload_time += biomat.buff_value
		
		var default_armor := BioMatResource.BUFFS_DEFAULT_VALUES[BioMatResource.BuffTypes.ARMOR]
		max_armor = default_armor
		for biomat: BioMatResource in biomats_perm[BioMatResource.BuffTypes.ROOT]:
			max_armor += biomat.buff_value
		
		current_armor = int(max_armor)
