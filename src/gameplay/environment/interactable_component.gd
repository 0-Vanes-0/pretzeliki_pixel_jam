class_name InteractableComponent
extends Area2D

signal interacted(player: Player)

const HOLD_TIME := 2.0 # seconds
const INTERACT_DELAY := 2.0 # seconds
var _hold_timer := 0.0
var _holding := false
var _interacted_timer: float
var _player: Player
@export var is_held := false
@export var is_one_interaction := true
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var label: Label
@export var bar: TextureProgressBar


func _ready() -> void:
	assert(coll_shape and label and bar)
	_interacted_timer = INTERACT_DELAY
	label.hide()
	bar.hide()
	
	self.body_entered.connect(
			func(body: Node2D):
				if body is Player:
					_player = body
					label.show()
	)
	self.body_exited.connect(
			func(body: Node2D):
				if body is Player:
					_player = null
					label.hide()
	)
	Global.input_mode_changed.connect(_on_input_mode_changed)


func _physics_process(delta: float) -> void:
	if _player:
		_interacted_timer += delta
	
	if _player and is_held and _holding:
		_hold_timer += delta
		bar.value = bar.max_value * (_hold_timer / HOLD_TIME)
		if _hold_timer >= HOLD_TIME:
			_holding = false
			bar.value = bar.min_value
			label.show()
			_on_interacted()


func _unhandled_input(event: InputEvent) -> void:
	if _player:
		if event.is_action_pressed("interact"):
			if is_held:
				_holding = true
				_hold_timer = 0.0
				label.hide()
				bar.show()
			else:
				_on_interacted()
		elif event.is_action_released("interact"):
			_holding = false
			label.show()
			bar.hide()
			bar.value = bar.min_value


func _on_interacted():
	if _interacted_timer >= INTERACT_DELAY:
		interacted.emit(_player)
		_interacted_timer = 0.0
		if is_one_interaction:
			_toggle_collision(false)
			bar.modulate.a = 0.0
			label.modulate.a = 0.0


func _on_input_mode_changed(input_mode: Global.InputModes):
	var event: InputEvent
	var events := InputMap.action_get_events("interact")
	for e in events:
		if (
				input_mode == Global.InputModes.KEYBOARD and (e is InputEventKey or e is InputEventMouse)
				or input_mode == Global.InputModes.JOYPAD and (e is InputEventJoypadButton or e is InputEventJoypadMotion)
		):
			event = e
			break
	label.text = InputEventHelper.get_text(event) if event != null else ""


func _toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)
