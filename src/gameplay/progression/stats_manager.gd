class_name StatsManager
extends Node

var hp: int
@export var max_hp: int = 100
@export var speed: float = 200.0
#@export var biomats_temp: Array[BioMatResource]
@export var biomats_perm: Array[BioMatResource]


func add_biomat(biomat_resource: BioMatResource):
	biomats_perm.append(biomat_resource)
	#_update_player_stats() ?
