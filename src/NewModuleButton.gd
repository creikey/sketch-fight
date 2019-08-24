extends Button

class_name NewModuleButton

var module_type: String = "" setget set_module_type

func _ready():
	self.module_type = "weapon_laser"

func set_module_type(module_type: String):
	if module_type == "":
		icon = null
		text = ""
		return
	if not module_type in Module.module_paths.keys():
		printerr("Unknown module type: ", module_type)
	name = module_type
	icon = load(Module.module_paths[module_type][1])
	text = module_type.capitalize()