extends Node2D

class_name Construct

signal resource_cost_changed(new_resource_cost)

var resource_cost: float = 0 setget set_resource_cost,my_get_resource_cost

func set_resource_cost(new_resource_cost):
	resource_cost = new_resource_cost
	emit_signal("resource_cost_changed", my_get_resource_cost())

func my_get_resource_cost() -> float:
	AbstractMethods.unimplemented("my_get_resource_cost", "Construct")
	return resource_cost