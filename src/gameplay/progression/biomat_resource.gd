class_name BioMatResource
extends Resource

enum BuffTypes {
	NONE = 0, TUTORIAL, DASH, ROOT, ARMOR
}
const BUFFS_CHUNKS := { # BuffTypes: int
	BuffTypes.TUTORIAL: 5,
	BuffTypes.DASH: 10,
	BuffTypes.ROOT: 5,
	BuffTypes.ARMOR: 5,
}
const BUFFS_DEFAULT_VALUES := { # BuffTypes: float
	BuffTypes.TUTORIAL: 0.0,
	BuffTypes.DASH: 6.0, # 6 sec reload - 0.1 sec each biomat ?
	BuffTypes.ROOT: 25.0, # 25 sec reload - 1 sec each biomat ?
	BuffTypes.ARMOR: 1.0, # 1 armor + 0.2 each biomat ?
}

@export var color: Color = Color.WHITE
@export var hp_buff: int = -1 # TODO: float or int?
@export var speed_buff_percent: float = -1.0 # TODO: float or int?
@export var buff_type: BuffTypes = BuffTypes.NONE
@export var buff_value: float = 0.0
