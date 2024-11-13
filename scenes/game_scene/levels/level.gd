class_name Level
extends Node2D

@export_group("Required Children")
@export var enemies: EnemyCollectionNode
@export var biomats: BioMatCollectionNode
@export var player: Player
@export var main_camera: PhantomCamera2D
@export var aim: Aim


func _ready() -> void:
	assert(enemies and biomats and player and main_camera and aim)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$Enemies/Enemy.died.connect(_on_enemy_died)


func _physics_process(delta: float) -> void:
	player.current_look_direction = aim.get_direction()
	main_camera.position = player.position + aim.get_direction() / 2
	
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second()) + " fps"


func _on_enemy_died(biomat_resource: BioMatResource, position: Vector2):
	var biomat := BioMat.create(biomat_resource)
	biomat.position = position
	biomat.collected.connect(
			func(resource: BioMatResource):
				player.stats.add_biomat(resource)
	)
	biomats.add_child(biomat)
