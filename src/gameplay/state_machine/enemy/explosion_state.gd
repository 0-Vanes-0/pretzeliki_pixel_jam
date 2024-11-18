class_name ExplosionState
extends EnemyState

@export var _enemy_explosion : PackedScene

func enter():
	enemy.toggle_collision(false)
	var enemy_explosion : EnemyExplosion = _enemy_explosion.instantiate()
	enemy_explosion.global_position = enemy.global_position
	enemy.get_parent().add_child(enemy_explosion)
	#enemy.sprite.play(enemy.Animations.DIE)
	enemy.died.emit(enemy.biomat_resource, enemy.position)
	
	enemy.queue_free()


func update(delta: float):
	pass


func physics_update(delta: float):
	pass


func exit():
	pass
