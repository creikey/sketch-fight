extends Node2D

class_name Module

const module_paths = {
	#               [path to usable,            path to new icon            ]
	"weapon_laser": ["res://WeaponLaser.tscn", "res://weapon-laser-icon.png"]
}

# warning-ignore:unused_argument
func my_target_click(in_target: Vector2) -> void:
	AbstractMethods.unimplemented("target_click", "Module")

static func get_module(module_name: String) -> Array:
	if not module_name in module_paths.keys():
		printerr("Unknown module type: ", module_name)
		return []
	return module_paths[module_name]

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func my_fire(ship_rotation: float, ship_position: Vector2) -> void:
	AbstractMethods.unimplemented("fire", "Module")