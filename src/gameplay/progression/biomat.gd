class_name BioMat
extends Area2D

@export var resource: BioMatResource
@export_group("Required Children")
@export var sprite: AnimatedSprite2D


static func create(resource: BioMatResource) -> BioMat:
	var biomat := Preloader.biomat.instantiate() as BioMat
	biomat.resource = resource
	return biomat


func _ready() -> void:
	assert(sprite)
