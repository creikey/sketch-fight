extends Node2D

class_name LineSet

var points: Array = []
var outline_points: PoolVector2Array = PoolVector2Array()
export var fill_color: Color = Color() setget set_fill_color
export var outline_color: Color = Color()
var outline_width: float = 3.0

onready var polygon_2d = get_node("Polygon2D")

func _ready():
	polygon_2d.antialiased = true

func _draw():
	draw_polyline(outline_points, outline_color, outline_width, true)

func regenerate_polygon():
	outline_points = PoolVector2Array(points)
	if outline_points.size() > 2:
		outline_points.append(outline_points[0])
	polygon_2d.polygon = outline_points
	update()

func set_fill_color(new_fill_color):
	fill_color = new_fill_color
	if polygon_2d:
		polygon_2d.color = new_fill_color