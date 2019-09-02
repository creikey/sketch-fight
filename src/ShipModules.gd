extends Node2D

class_name ShipModules

signal modules_changed(new_resource_cost)

export (PackedScene) var editing_module_slot_pack
export (PackedScene) var module_slot_pack

var modules_are_editing = false

func _ready():
	$LookAheadRaycast2D.add_exception(get_parent())
	$LookRightRaycast2D.add_exception(get_parent())

func _unhandled_input(event):
	if event.is_action_pressed("g_fire") and is_network_master() and modules_are_editing == false and get_parent().selected:
		my_fire_modules()
		rpc("my_fire_modules")

remote func my_fire_modules():
	for m in get_module_slots():
		for c in m.get_children():
			c.my_fire(get_parent().global_transform.get_rotation(), get_parent().global_transform.origin, get_parent().team, get_parent())

func get_module_slots() -> Array:
	return $Modules.get_children()

func to_editing_mode():
	$CollisionShape2D.disabled = true
	if modules_are_editing:
		return
	modules_are_editing = true
	for c in get_module_slots():
		var cur_editing_module_slot: EditingModuleSlot = editing_module_slot_pack.instance()
		copy_properties(c, cur_editing_module_slot)
# warning-ignore:return_value_discarded
		cur_editing_module_slot.connect("module_changed", self, "_module_changed")
		c.replace_by(cur_editing_module_slot, false)

func _module_changed(_new_module_type):
	var cur_resource_count = 0.0
	for c in get_module_slots():
#		print(c.module_type)
		if c.module_type == "":
			continue
		cur_resource_count += Module.module_data[c.module_type][2]
	emit_signal("modules_changed", cur_resource_count)

func to_battle_mode():
	var shape_owner = get_parent().create_shape_owner(get_parent())
	get_parent().shape_owner_add_shape(shape_owner, $CollisionShape2D.shape)
	$CollisionShape2D.disabled = false
	if modules_are_editing == false:
		return
	modules_are_editing = false
	for c in get_module_slots():
		var cur_battle_module: ModuleSlot = module_slot_pack.instance()
		copy_properties(c, cur_battle_module)
		c.replace_by(cur_battle_module, false)

static func copy_property(node_source: Node, node_output: Node, property_name: String):
	node_output.set(property_name, node_source.get(property_name))

func copy_properties(module_source: ModuleSlot, module_output: ModuleSlot):
	var identical_properties = [
		"rect_position",
		"module_type",
		"name"
	]
	for p in identical_properties:
		copy_property(module_source, module_output, p)
	module_output.set_module_type(module_source.module_type)

func get_arg() -> Dictionary:
	var output = {}
	for m in get_module_slots():
		output[m.name] = m.module_type
	return output

func setup_from_one_arg(in_arg: Dictionary):
	for m in in_arg.keys():
		$Modules.get_node(m).set_module_type(in_arg[m])