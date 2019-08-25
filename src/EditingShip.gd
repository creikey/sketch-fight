extends Construct

class_name EditingShip

const ships_path = "res://"
const ship_data = {
	"FighterShip": [ships_path + "FighterShip.tscn", 40]
}

var ship_type = "FighterShip"

func _ready():
	update_ship()

func update_ship():
	print(ship_data[ship_type][0])
	var cur_ship: ShipModules = load(ship_data[ship_type][0]).instance()
	add_child(cur_ship)
# warning-ignore:return_value_discarded
	cur_ship.connect("modules_changed", self, "_ship_modules_changed")
	cur_ship.to_editing_mode()

func get_module_arg() -> Dictionary:
	return get_node(ship_type).get_arg()

func my_get_resource_cost() -> float:
	return resource_cost + ship_data[ship_type][1]

func _ship_modules_changed(new_resource_cost):
	self.resource_cost = new_resource_cost