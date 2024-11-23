class_name Suit
extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.suit_state = "ship"
		self.queue_free()
