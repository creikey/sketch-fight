extends Node2D

class_name Sketch

var layers: Array = [] # array of layer nodes

func _ready():
	add_layer()

func add_layer():
	var new_layer_node = Node2D.new()
	var layer_index = layers.size()
	new_layer_node.name = "Layer" + str(layer_index)
	layers.append(new_layer_node)
	add_child(new_layer_node)
	return layer_index

func insert_lineset(in_lineset: LineSet, layer_index: int):
	layers[layer_index].add_child(in_lineset)