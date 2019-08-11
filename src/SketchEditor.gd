extends Node2D

export (PackedScene) var line_set_pack

var cur_sketch: Sketch = null
var cur_layer: int = 0
var cur_lineset: LineSet = null

onready var ui = get_node("UI")

func new_sketch():
	if cur_sketch != null:
		printerr("Current sketch not set to null after done editing!")
		cur_sketch.queue_free()
		cur_sketch = null
	if cur_lineset != null:
		cur_lineset.queue_free()
		cur_lineset = null
	cur_sketch = Sketch.new()
	cur_sketch.name = "CurSketch"
	add_child(cur_sketch)
	
func _ready():
	new_sketch()

func _input(event):
	if event.is_action_pressed("ui_new_point"):
		if $UI/MousePuck.out_of_editing_pad:
			return
		if cur_lineset == null:
			cur_lineset = line_set_pack.instance()
			cur_lineset.name = "CurLineSet"
			add_child(cur_lineset)
		cur_lineset.points.append(ui.get_node("MousePuck").rect_global_position)
		cur_lineset.regenerate_polygon()

func write_layer():
	cur_sketch.insert_lineset(cur_lineset, cur_layer)
	cur_lineset.queue_free()
	cur_lineset = null