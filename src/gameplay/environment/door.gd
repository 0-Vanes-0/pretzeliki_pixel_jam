class_name Door
extends StaticBody2D

@export_group("Required Children")
@export var coll_shape: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var interactable1: InteractableComponent
@export var interactable2: InteractableComponent
var _nav_region: NavigationRegion2D


func _ready() -> void:
	_toggle_collision(true)
	_nav_region = (get_parent() as TileMapLayer).get_parent().get_parent() as NavigationRegion2D
	assert(_nav_region)
	
	interactable1.interacted.connect(_on_door_interacted)
	interactable2.interacted.connect(_on_door_interacted)


func _on_door_interacted(_player: Player):
	if coll_shape.disabled:
		_toggle_collision(true)
		sprite.play("closed")
	else:
		_toggle_collision(false)
		sprite.play("opened")
	
	_nav_region.bake_navigation_polygon()


func _toggle_collision(enabled: bool):
	coll_shape.set_deferred("disabled", not enabled)
