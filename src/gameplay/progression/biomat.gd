class_name BioMat
extends Node2D

signal collected(resource: BioMatResource)

@export var resource: BioMatResource
@export_group("Required Children")
@export var interactable: InteractableComponent
@export var sprite: AnimatedSprite2D


static func create(resource: BioMatResource) -> BioMat:
	var biomat := Preloader.biomat.instantiate() as BioMat
	biomat.resource = resource
	return biomat


func _ready() -> void:
	assert(interactable and sprite)
	interactable.interacted.connect(
			func():
				collected.emit(resource)
	, CONNECT_ONE_SHOT)
