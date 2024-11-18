class_name BioMatResource
extends Resource

enum Abilities {
	NONE
}

@export var color: Color = Color.WHITE
@export var hp_buff: float = -1.0
@export var speed_buff_percent: float = -1.0
@export var ability_buff_type: Abilities = Abilities.NONE
@export var ability_buff: float = 0.0
