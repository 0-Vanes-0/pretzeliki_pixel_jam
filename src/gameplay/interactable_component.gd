class_name InteractableComponent
extends Area2D

signal interacted


func _ready() -> void:
	self.body_entered.connect(
			func(body: Node2D):
				if body is Player:
					pass
	)
	self.body_exited.connect(
			func(body: Node2D):
				if body is Player:
					pass
	)
