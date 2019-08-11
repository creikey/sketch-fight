extends Node2D

export (PackedScene) var line_set_pack
export (PackedScene) var possible_point_pack

var cur_sketch: Sketch = null
var cur_layer: int = 0
var cur_lineset: LineSet = null

var possible_points: Array = []

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

func ensure_lineset():
	if cur_lineset == null:
		cur_lineset = line_set_pack.instance()
		cur_lineset.name = "CurLineSet"
		add_child(cur_lineset)

func _input(event):
	if event.is_action_pressed("ui_new_point"):
		if $UI/MousePuck.out_of_editing_pad:
			return
		ensure_lineset()
		add_point(ui.get_node("MousePuck").rect_global_position)
		add_point(MousePuck.get_mirrored_pos(ui.get_node("MousePuck").rect_global_position))
#		cur_lineset.points.append(ui.get_node("MousePuck").rect_global_position)
#		cur_lineset.regenerate_polygon()
#	elif event.is_action_pressed("ui_new_mirrored_point"):
#		if $UI/MousePuck.out_of_editing_pad:
#			return
#		ensure_lineset()
#		cur_lineset.points.append(MousePuck.get_mirrored_pos(ui.get_node("MousePuck").rect_global_position))
#		cur_lineset.regenerate_polygon()

func add_point(new_position: Vector2):
	var cur_possible_point = possible_point_pack.instance()
	possible_points.append(cur_possible_point)
	$PossiblePoints.add_child(cur_possible_point)
	cur_possible_point.global_position = new_position

func write_layer():
	cur_sketch.insert_lineset(cur_lineset, cur_layer)
	cur_lineset.queue_free()
	cur_lineset = null