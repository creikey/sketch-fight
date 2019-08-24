extends ModuleSlot

class_name EditingModuleSlot

export (PackedScene) var piemenu_pack
export (PackedScene) var new_module_button_pack

var cur_pie_menu: PieMenu = null

func _gui_input(event):
	if event.is_action_pressed("g_place_module"):
		cur_pie_menu = piemenu_pack.instance()
#		add_child(cur_pie_menu)
#		get_node("/root/World/UI").add_child(cur_pie_menu)
		add_child(cur_pie_menu)
		cur_pie_menu.delete_on_hide = true
		cur_pie_menu.rect_global_position = rect_global_position + Vector2(-cur_pie_menu.rect_size.x, cur_pie_menu.rect_size.y)/2
		add_module_option("weapon_laser", cur_pie_menu, new_module_button_pack)
		
		cur_pie_menu.show()
# warning-ignore:return_value_discarded
		cur_pie_menu.connect("option_chosen", self, "pie_menu_chosen")

func pie_menu_chosen(module_type: String):
	if module_type == "back":
		pass
	elif module_type == "remove":
		set_module_type("")
	else:
		set_module_type(module_type)

# TODO use in other module editing nodes for upgrade paths
static func add_module_option(module_name: String, pie_menu: PieMenu, module_button_pack: PackedScene):
	var cur_button = module_button_pack.instance()
	cur_button.set_module_type(module_name)
	pie_menu.add_child(cur_button)
