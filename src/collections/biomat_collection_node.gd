class_name BioMatCollectionNode
extends Node2D


func _ready() -> void:
	for child in self.get_children():
		assert(child is Enemy)


func get_array() -> Array[Enemy]:
	var array: Array[Enemy] = []
	for child: Enemy in self.get_children():
		array.append(child)
	return array


func clear():
	for child in self.get_children():
		child.queue_free()


func size() -> int:
	return self.get_child_count()
