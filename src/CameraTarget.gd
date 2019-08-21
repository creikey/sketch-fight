extends Node2D

export var smoothing = 5.0
export var zoom_amount = 0.15

var target_zoom = 1.0

func _process(delta):
	if Input.is_action_pressed("g_pan"):
		global_position = get_global_mouse_position()
	var c = smoothing * delta
	var output_zoom = ((target_zoom - $Camera2D.zoom.x) * c) + $Camera2D.zoom.x
	$Camera2D.zoom.x = output_zoom
	$Camera2D.zoom.y = output_zoom

func _input(event):
	if event.is_action("ui_zoom_in"):
		target_zoom -= zoom_amount
		target_zoom = clamp(target_zoom, 0.5, 4.0)
	elif event.is_action("ui_zoom_out"):
		target_zoom += zoom_amount
		target_zoom = clamp(target_zoom, 0.5, 4.0)