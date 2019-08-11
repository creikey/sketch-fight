extends Node2D

var layers: Array = []

func _ready():
	add_layer()
	add_layer()
	add_layer()

func add_layer():
	var new_layer_node = Node2D.new()
	var layer_index = layers.size()
	new_layer_node.name = "Layer" + str(layer_index + 1)
	layers.append(new_layer_node)
	add_child(new_layer_node)
	return layer_index