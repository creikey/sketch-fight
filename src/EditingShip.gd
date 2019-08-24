extends Construct

class_name EditingShip

const ships_path = "res://"

var ship_type = "FighterShip"

func _ready():
	update_ship()

func update_ship():
	var cur_ship: ShipModules = load(ships_path + ship_type + ".tscn").instance()
	add_child(cur_ship)
# warning-ignore:return_value_discarded
	cur_ship.connect("modules_changed", self, "_ship_modules_changed")
	cur_ship.to_editing_mode()

func get_module_arg() -> Dictionary:
	return get_node(ship_type).get_arg()

func my_get_resource_cost() -> float:
	return resource_cost

func _ship_modules_changed(new_resource_cost):
	self.resource_cost = new_resource_cost