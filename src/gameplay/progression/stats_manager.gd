class_name StatsManager
extends Node

signal health_depleted

@export var max_hp: int = 100
@export var speed: float = 200.0
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
var root_reload_time: float
var max_armor: float

var armor: int
var current_hp: int
var current_speed: int


func _ready() -> void:
	current_hp = max_hp
	current_speed = speed
	dash_reload_time = 0.0
	root_reload_time = 0.0
	max_armor = 0.0
	_update_player_stats()


func add_biomat(biomat_resource: BioMatResource):
	biomats_temp[biomat_resource.buff_type] = biomat_resource
	_update_player_stats()


func adjust_health(value: int, is_from_biomat := false):
	var min_value: int = 0
	if is_from_biomat:
		min_value = 5
	
	current_hp = clampi(value, min_value, max_hp)
	if current_hp == 0:
		health_depleted.emit()


func _update_player_stats(is_on_terminal := false):
	for buff_type in biomats_temp.keys():
		var chunk: int = BioMatResource.BUFFS_CHUNKS.get(buff_type)
		var temp_array: Array[BioMatResource] = biomats_temp.get(buff_type)
		var perm_array: Array[BioMatResource] = biomats_perm[buff_type]
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
		
		var default_root_reload_time: float = BioMatResource.BUFFS_DEFAULT_VALUES[BioMatResource.BuffTypes.ROOT]
		root_reload_time = default_root_reload_time
		for biomat: BioMatResource in biomats_perm[BioMatResource.BuffTypes.ROOT]:
			root_reload_time += biomat.buff_value
		
		var default_armor := BioMatResource.BUFFS_DEFAULT_VALUES[BioMatResource.BuffTypes.ARMOR]
		max_armor = default_armor
		for biomat: BioMatResource in biomats_perm[BioMatResource.BuffTypes.ROOT]:
			max_armor += biomat.buff_value
		
		armor = int(max_armor)
