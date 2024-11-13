class_name DeadEnemyState
extends EnemyState


func enter():
	enemy.toggle_collision(false)
	enemy.sprite.play(enemy.Animations.DIE)
	enemy.died.emit(enemy.biomat_resource, enemy.position)


func update(delta: float):
	pass


func physics_update(delta: float):
	pass


func exit():
	pass


