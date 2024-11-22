class_name TerminalInterface
extends Control

@export_group("Required Children")
@export var hp_bar: TextureProgressBar
@export var hp_label: Label
@export var grenade_label: Label
@export var dash_label: Label
@export var dash_mutate_button: TextureButton
@export var stun_label: Label
@export var stun_mutate_button: TextureButton
@export var armor_label: Label
@export var armor_mutate_button: TextureButton
@export var trade_button: Button

var _player: Player
var _dash_upgrade_counter: int = 0
var _stun_upgrade_counter: int = 0
var _armor_upgrade_counter: int = 0


func _ready() -> void:
	assert(hp_bar and hp_label and grenade_label and dash_label and dash_mutate_button and stun_label and stun_mutate_button and armor_label and armor_mutate_button and trade_button)
	_player = get_tree().get_first_node_in_group("player")
	assert(_player)
	self.hide()


func _on_dash_mutate_button_pressed() -> void:
	_player.stats.update_dash_stats()
	_dash_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)
	dash_mutate_button.disabled = true


func _on_stun_mutate_button_pressed() -> void:
	_player.stats.update_stun_stats()
	_stun_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.STUN).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.STUN)
	stun_mutate_button.disabled = true


func _on_armor_mutate_button_pressed() -> void:
	_player.stats.update_armor_stats()
	_armor_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)
	armor_mutate_button.disabled = true


func _on_trade_temp_bio_mat_button_pressed() -> void:
	var hp_heal := 0.0
	var speed_restore_percent := 0.0
	var grenades_restore := 0.0
	for buff_type in _player.stats.biomats_temp.keys():
		var array: Array = _player.stats.biomats_temp.get(buff_type)
		for biomat: BioMatResource in array:
			hp_heal += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("hp")
			speed_restore_percent += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("speed_percent")
			grenades_restore += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("grenades")
		array.clear()
	
	_player.stats.adjust_health( int(hp_heal) )
	_player.stats.adjust_speed(speed_restore_percent)
	_player.stats.adjust_grenades( int(grenades_restore) )

	trade_button.disabled = true


func appear():
	dash_mutate_button.disabled = not _can_mutate_dash()
	stun_mutate_button.disabled = not _can_mutate_stun()
	armor_mutate_button.disabled = not _can_mutate_armor()
	trade_button.disabled = not _has_temp_biomats()
	
	self.position = Vector2.DOWN * Global.SCREEN_HEIGHT
	self.show()
	var tween := create_tween()
	tween.tween_property(
			self, "position",
			Vector2(0,0),
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func disappear():
	var tween := create_tween()
	tween.tween_property(
			self, "position",
			Vector2.UP * Global.SCREEN_HEIGHT,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(self.hide)


func _can_mutate_dash() -> bool:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH) < _dash_upgrade_counter


func _can_mutate_stun() -> bool:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.STUN).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.STUN) < _stun_upgrade_counter


func _can_mutate_armor() -> bool:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH) < _armor_upgrade_counter


func _has_temp_biomats() -> bool:
	var counter := 0
	for array: Array in _player.stats.biomats_temp.values():
		counter += array.size()
	return counter > 0
