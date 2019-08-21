tool
extends ColorRect

export (NodePath) var camera_path

onready var camera_node: Camera2D = get_node(camera_path)

func _ready():
	update_shader_transform()
	if not Engine.editor_hint:
		set_process(true)
	else:
		set_process(false)

func _process(delta):
	update_shader_transform()

func update_shader_transform():
	if camera_node != null:
#		print(camera_node.get_canvas_transform())
		material.set_shader_param("global_transform", camera_node.get_canvas_transform())
		material.set_shader_param("global_translation", camera_node.get_canvas_transform().origin)
		material.set_shader_param("zoom", camera_node.zoom)