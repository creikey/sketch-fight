extends Control

export (Color) var color = Color()
export (int) var size = 6.0

func _process(delta):
	rect_global_position = get_viewport().get_mouse_position()

func _draw():
	draw_circle(Vector2(), size, color)