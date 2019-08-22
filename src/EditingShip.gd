extends Node2D

class_name EditingShip

const ships_path = "res://"

var ship_type = "FighterShip"

func _ready():
	update_ship()

func update_ship():
	var cur_ship = load(ships_path + ship_type + ".tscn").instance()
	cur_ship.disabled = true
	add_child(cur_ship)