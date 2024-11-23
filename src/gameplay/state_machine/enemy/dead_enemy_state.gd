class_name DeadEnemyState
extends EnemyState


func enter():
	enemy.toggle_collision(false)
	enemy.animate("die")
	enemy.died.emit(enemy.biomat_resource, enemy.position)
	enemy.remove_from_group("enemy")


func update(delta: float):
	pass


func physics_update(delta: float):
	pass


func exit():
	pass
