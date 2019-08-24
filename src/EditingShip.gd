extends Node2D

class_name EditingShip

const ships_path = "res://"

var ship_type = "FighterShip"

func _ready():
	update_ship()

func update_ship():
	var cur_ship: ShipModules = load(ships_path + ship_type + ".tscn").instance()
	add_child(cur_ship)
	cur_ship.to_editing_mode()