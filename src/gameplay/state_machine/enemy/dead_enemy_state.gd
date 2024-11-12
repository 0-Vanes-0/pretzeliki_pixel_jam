class_name DeadEnemyState
extends EnemyState


func enter():
	enemy.sprite.play(enemy.Animations.DIE)
	enemy.emit_died()


func update(delta: float):
	pass


func physics_update(delta: float):
	pass


func exit():
	pass


