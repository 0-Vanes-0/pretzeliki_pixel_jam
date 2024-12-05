## Code by Maaack
extends PauseMenu


func _ready() -> void:
	Global.suit_state_changed.connect(_on_suit_changed)


func _on_suit_changed():
	%ExitButton.text = " Выключить симуляцию " if Global.suit_state == "simulation" else " Самоликвидироваться "
