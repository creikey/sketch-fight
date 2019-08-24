extends Node2D

class_name Module

const module_data = {
	#               [path to usable,            path to new icon              resource cost]
	"weapon_laser": ["res://WeaponLaser.tscn", "res://weapon-laser-icon.png", 300          ]
}

# warning-ignore:unused_argument
func my_target_click(in_target: Vector2) -> void:
	AbstractMethods.unimplemented("target_click", "Module")

static func get_module(module_name: String) -> Array:
	if not module_name in module_data.keys():
		printerr("Unknown module type: ", module_name)
		return []
	return module_data[module_name]

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func my_fire(ship_rotation: float, ship_position: Vector2, team: String, ship: PhysicsBody2D) -> void:
	AbstractMethods.unimplemented("fire", "Module")