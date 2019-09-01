tool
extends Control

export var resolution = 32 setget set_resolution
export var size = 100.0 setget set_size
export var color = Color() setget set_color
export var width = 30.0 setget set_width
export var center_in_parent = false setget set_center_in_parent

func _draw():
	var cur_rotation = 0.0
	var points: Array = []
	rect_size = Vector2(2*size + width, 2*size + width)
	while cur_rotation < 2*PI + 2*(2*PI)/resolution:
		points.append(Vector2(size, 0).rotated(cur_rotation))
		points[points.size() - 1] += rect_size / 2
		cur_rotation += (2*PI)/resolution
	draw_polyline(points, color, width, true)
	if center_in_parent:
		rect_position = -rect_size/2

func set_center_in_parent(new_center_in_parent):
	center_in_parent = new_center_in_parent
	update()

func set_resolution(new_resolution):
	resolution = new_resolution
	update()

func set_size(new_size):
	size = new_size
	update()

func set_color(new_color):
	color = new_color
	update()

func set_width(new_width):
	width = new_width
	update()