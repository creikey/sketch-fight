extends CollisionPolygon2D

class_name ShipModules

export (PackedScene) var editing_module_slot_pack
export (PackedScene) var module_slot_pack

var modules_are_editing = false

func get_modules() -> Array:
	return $Modules.get_children()

func to_editing_mode():
	disabled = true
	if modules_are_editing:
		return
	modules_are_editing = true
	for c in get_modules():
		var cur_editing_module: EditingModuleSlot = editing_module_slot_pack.instance()
		copy_properties(c, cur_editing_module)
		c.replace_by(cur_editing_module, false)

func to_battle_mode():
	disabled = false
	if modules_are_editing == false:
		return
	modules_are_editing = false
	for c in get_modules():
		var cur_battle_module: ModuleSlot = module_slot_pack.instance()
		copy_properties(c, cur_battle_module)
		c.replace_by(cur_battle_module, false)

static func copy_property(node_source: Node, node_output: Node, property_name: String):
	node_output.set(property_name, node_source.get(property_name))

func copy_properties(module_source: ModuleSlot, module_output: ModuleSlot):
	var identical_properties = [
		"position",
		"module_type",
		"name"
	]
	for p in identical_properties:
		copy_property(module_source, module_output, p)