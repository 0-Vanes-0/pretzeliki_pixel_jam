class_name TerminalInterface
extends Control

@export_group("Required Children")
@export var hp_bar: TextureProgressBar
@export var hp_label: Label
@export var grenade_label: Label
@export var dash_hbox: HBoxContainer
@export var dash_label: Label
@export var dash_mutate_button: TextureButton
@export var stun_hbox: HBoxContainer
@export var stun_label: Label
@export var stun_mutate_button: TextureButton
@export var armor_hbox: HBoxContainer
@export var armor_label: Label
@export var armor_mutate_button: TextureButton
@export var trade_button: Button

@export var dash_biomat_label: Label
@export var stun_biomat_label: Label
@export var armor_biomat_label: Label

var _player: Player
var _dash_upgrade_counter: int = 0
var _stun_upgrade_counter: int = 0
var _armor_upgrade_counter: int = 0


func _ready() -> void:
	assert(hp_bar and hp_label and grenade_label and dash_label and dash_mutate_button and stun_label and stun_mutate_button and armor_label and armor_mutate_button and trade_button)
	assert(dash_hbox and stun_hbox and armor_hbox)
	assert(dash_biomat_label and stun_biomat_label and armor_biomat_label)
	_player = get_tree().get_first_node_in_group("player")
	assert(_player)
	
	hp_bar.min_value = 0
	self.hide()


func _on_dash_mutate_button_pressed() -> void:
	_player.stats.update_dash_stats()
	_dash_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)
	dash_mutate_button.disabled = true
	_set_dash(_player.stats.dash_reload_time)


func _on_stun_mutate_button_pressed() -> void:
	_player.stats.update_stun_stats()
	_stun_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.STUN).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.STUN)
	stun_mutate_button.disabled = true
	_set_stun(_player.stats.stun_reload_time)


func _on_armor_mutate_button_pressed() -> void:
	_player.stats.update_armor_stats()
	_armor_upgrade_counter = _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)
	armor_mutate_button.disabled = true
	_set_armor(_player.stats.current_armor)


func _on_trade_temp_bio_mat_button_pressed() -> void:
	var max_hp_buff: int = 0
	var hp_heal := 0.0
	var speed_restore_percent := 0.0
	var grenades_restore := 0.0
	for buff_type in _player.stats.biomats_temp.keys():
		var array: Array = _player.stats.biomats_temp.get(buff_type)
		for biomat: BioMatResource in array:
			if buff_type == BioMatResource.BuffTypes.TUTORIAL:
				max_hp_buff += 10
			hp_heal += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("hp")
			speed_restore_percent += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("speed_percent")
			grenades_restore += BioMatResource.BUFF_TRADE_VALUES.get(buff_type).get("grenades")
		array.clear()
	
	_player.stats.max_hp += max_hp_buff
	_player.stats.adjust_health( int(hp_heal) )
	_player.stats.adjust_speed(speed_restore_percent)
	_player.stats.adjust_grenades( int(grenades_restore) )
	
	_set_hp(_player.stats.current_hp, _player.stats.max_hp)
	_set_grenades(_player.stats.current_grenades)
	
	dash_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.DASH))
	stun_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.STUN) + _get_biomat_count(BioMatResource.BuffTypes.TUTORIAL))
	armor_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.ARMOR))
	
	trade_button.disabled = true


func appear():
	dash_hbox.visible = _player.has_dash_ability()
	stun_hbox.visible = _player.has_stun_ability()
	armor_hbox.visible = _player.stats.max_armor > 0
	
	dash_mutate_button.disabled = _get_dash_upgrades_count() == _dash_upgrade_counter
	stun_mutate_button.disabled = _get_stun_upgrades_count() == _stun_upgrade_counter
	armor_mutate_button.disabled = _get_armor_upgrades_count() == _armor_upgrade_counter
	trade_button.disabled = not _has_temp_biomats()
	
	_set_hp(_player.stats.current_hp, _player.stats.max_hp)
	_set_grenades(_player.stats.current_grenades)
	
	dash_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.DASH))
	stun_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.STUN) + _get_biomat_count(BioMatResource.BuffTypes.TUTORIAL))
	armor_biomat_label.text = str(_get_biomat_count(BioMatResource.BuffTypes.ARMOR))
	
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


func _get_dash_upgrades_count() -> int:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)


func _get_stun_upgrades_count() -> int:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.STUN).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.STUN)


func _get_armor_upgrades_count() -> int:
	return _player.stats.biomats_perm.get(BioMatResource.BuffTypes.DASH).size() / BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)


func _has_temp_biomats() -> bool:
	var counter := 0
	for array: Array in _player.stats.biomats_temp.values():
		counter += array.size()
	return counter > 0


func _set_hp(value: int, max_value: int = 0):
	if max_value > 0:
		hp_bar.max_value = max_value
	hp_bar.value = value
	hp_label.text = str(hp_bar.value) + "/" + str(hp_bar.max_value)


func _set_grenades(value: int):
	grenade_label.text = str(value)


func _set_dash(value: float):
	grenade_label.text = String.num(value, 1) + " сек"


func _set_stun(value: float):
	stun_label.text = String.num(value, 1) + " сек"


func _set_armor(value: int):
	armor_label.text = str(value) + " шт"


func _get_biomat_count(type: BioMatResource.BuffTypes) -> int:
	match type:
		BioMatResource.BuffTypes.TUTORIAL:
			return _player.stats.biomats_temp.get(BioMatResource.BuffTypes.TUTORIAL).size()
		BioMatResource.BuffTypes.DASH:
			return _player.stats.biomats_temp.get(BioMatResource.BuffTypes.DASH).size() + (_get_dash_upgrades_count() - _dash_upgrade_counter) * BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.DASH)
		BioMatResource.BuffTypes.STUN:
			return _player.stats.biomats_temp.get(BioMatResource.BuffTypes.STUN).size() + (_get_stun_upgrades_count() - _stun_upgrade_counter) * BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.STUN)
		BioMatResource.BuffTypes.ARMOR:
			return _player.stats.biomats_temp.get(BioMatResource.BuffTypes.ARMOR).size() + (_get_armor_upgrades_count() - _armor_upgrade_counter) * BioMatResource.BUFFS_CHUNKS.get(BioMatResource.BuffTypes.ARMOR)
		_:
			return 0
