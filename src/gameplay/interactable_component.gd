class_name InteractableComponent
extends Area2D

signal interacted(player: Player)

const HOLD_TIME := 2.0 # seconds
var _timer := 0.0
var _holding := false
var _player: Player
@export var is_held := false
@export var is_one_interaction := true
@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var label: Label
@export var bar: TextureProgressBar


func _ready() -> void:
	assert(coll_shape and label and bar)
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


func _physics_process(delta: float) -> void:
	if _player and is_held and _holding:
		_timer += delta
		bar.value = bar.max_value * (_timer / HOLD_TIME)
		if _timer >= HOLD_TIME:
			_holding = false
			bar.value = bar.min_value
			label.show()
			_on_interacted()


func _unhandled_input(event: InputEvent) -> void:
	if _player:
		if event.is_action_pressed("interact"):
			if is_held:
				_holding = true
				_timer = 0.0
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
	interacted.emit(_player)
	if is_one_interaction:
		_toggle_collision(false)
		bar.modulate.a = 0.0
		label.modulate.a = 0.0


func _get_interact_action() -> String:
	var event: InputEvent
	var events := InputMap.action_get_events("interact")
	for e in events:
		if e is InputEventKey: # TODO: add detecting joypad
			event = e
	return InputEventHelper.get_text(event) if event != null else ""


func _toggle_collision(enable: bool):
	coll_shape.set_deferred("disabled", not enable)
