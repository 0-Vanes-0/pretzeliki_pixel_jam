class_name ControlCollectionNode
extends Node2D


func _ready() -> void:
	for child in self.get_children():
		assert(child is Control)


func get_array() -> Array[Control]:
	var array: Array[Control] = []
	for child: Control in self.get_children():
		array.append(child)
	return array


func clear():
	for child in self.get_children():
		child.queue_free()


func size() -> int:
	return self.get_child_count()
