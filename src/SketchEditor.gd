extends Node2D

export (PackedScene) var line_set_pack
export (PackedScene) var possible_point_pack

var cur_sketch: Sketch = null
var cur_layer: int = 0
var cur_lineset: LineSet = null

var left_possible_points: Array = []
var right_possible_points: Array = []

var camera_transform: Transform2D = Transform2D() setget set_camera_transform

onready var ui = get_node("PhysicalUI")

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
		if $PhysicalUI/MousePuck.out_of_editing_pad:
			return
		ensure_lineset()
		right_possible_points.append(add_point(ui.get_node("MousePuck").rect_global_position).global_position)
		left_possible_points.append(add_point(MousePuck.get_mirrored_pos(ui.get_node("MousePuck").rect_global_position)).global_position)
		cur_lineset.points = get_point_array()
		cur_lineset.regenerate_polygon()

func get_point_array():
	left_possible_points.sort_custom(self, "_sort_point")
	right_possible_points.sort_custom(self, "_sort_point")
	right_possible_points.invert()
	return left_possible_points + right_possible_points

func _sort_point(point_a: Vector2, point_b: Vector2):
	return point_a.y < point_b.y

func add_point(new_position: Vector2):
	var cur_possible_point = possible_point_pack.instance()
	$PossiblePoints.add_child(cur_possible_point)
	cur_possible_point.global_position = new_position
	return cur_possible_point

func write_layer():
	cur_sketch.insert_lineset(cur_lineset, cur_layer)
	cur_lineset.queue_free()
	cur_lineset = null

func set_camera_transform(new_camera_transform):
	camera_transform = new_camera_transform
	$PhysicalUI.transform = new_camera_transform