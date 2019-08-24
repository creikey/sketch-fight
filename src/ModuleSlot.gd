extends TextureRect

class_name ModuleSlot

signal module_changed(new_module_type)

var module_type: String = "" setget set_module_type

var cur_module = null

func set_module_type(new_module_type: String):
	module_type = new_module_type
	emit_signal("module_changed", new_module_type)
	if module_type == "":
		if cur_module:
			cur_module.queue_free()
			cur_module = null
		return
	cur_module = load(Module.get_module(new_module_type)[0]).instance()
	cur_module.position = rect_size/2
	add_child(cur_module)