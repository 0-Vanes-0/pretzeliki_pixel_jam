class_name EnemyExplosion
extends Area2D


@export var explosion_damage : float = 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(explosion_damage)


func _on_timer_timeout() -> void:
	queue_free()
	# TODO queue_free when animation is finished
	#set_deferred("monitoring", false)
