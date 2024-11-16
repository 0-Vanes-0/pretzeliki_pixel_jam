class_name EnemyExplosion
extends Area2D


@export var explosion_damage : float = 1

## чтобы не нанести урон два раза
var _damaged : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _damaged:
		body.take_damage(explosion_damage)
		_damaged = true


func _on_timer_timeout() -> void:
	queue_free()
	# TODO queue_free when animation is finished
	#set_deferred("monitoring", false)
