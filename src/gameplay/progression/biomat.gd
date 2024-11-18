class_name BioMat
extends Node2D

@export var resource: BioMatResource
@export_group("Required Children")
@export var interactable: InteractableComponent
@export var sprite: AnimatedSprite2D


static func create(resource: BioMatResource) -> BioMat:
	var biomat := Preloader.biomat.instantiate() as BioMat
	assert(biomat)
	biomat.resource = resource
	return biomat


func _ready() -> void:
	assert(interactable and sprite)
	sprite.modulate = resource.color
	interactable.interacted.connect(
			func(player: Player):
				player.stats.add_biomat(resource)
				self.queue_free()
	, CONNECT_ONE_SHOT)
