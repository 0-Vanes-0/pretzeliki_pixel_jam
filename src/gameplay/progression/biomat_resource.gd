class_name BioMatResource
extends Resource

enum BuffTypes {
	NONE = 0, TUTORIAL, DASH, STUN, ARMOR
}
const BUFFS_CHUNKS := { # BuffTypes: int
	BuffTypes.TUTORIAL: 5,
	BuffTypes.DASH: 10,
	BuffTypes.STUN: 5,
	BuffTypes.ARMOR: 3,
}
const BUFFS_DEFAULT_VALUES := { # BuffTypes: float
	BuffTypes.TUTORIAL: 0.0,
	BuffTypes.DASH: 6.0, # 6 sec reload - 0.1 sec each biomat ?
	BuffTypes.STUN: 25.0, # 25 sec reload - 1 sec each biomat ?
	BuffTypes.ARMOR: 1.0, # 1 armor + 0.2 each biomat ?
}
const BUFF_TRADE_VALUES := {
	BuffTypes.TUTORIAL: {
		"hp": 10.0,
		"speed_percent": 10.0,
		"grenades": 1.0,
	},
	BuffTypes.DASH: {
		"hp": 1.0,
		"speed_percent": 1.0,
		"grenades": 0.2,
	},
	BuffTypes.STUN: {
		"hp": 5.0,
		"speed_percent": 1.0,
		"grenades": 0.5,
	},
	BuffTypes.ARMOR: {
		"hp": 10.0,
		"speed_percent": 1.0,
		"grenades": 1.0,
	},
}

@export var color: Color = Color.WHITE
@export var hp_buff: int = -1 # TODO: float or int?
@export var speed_buff_percent: float = -1.0 # TODO: float or int?
@export var buff_type: BuffTypes = BuffTypes.NONE
@export var buff_value: float = 0.0



