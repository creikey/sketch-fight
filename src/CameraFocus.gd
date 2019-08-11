extends Node2D

export var smoothing = 5.0
export var zoom_amount = 0.1

var target_zoom = 1.0

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("ui_pan"):
			global_position += event.relative
	elif event.is_action("ui_zoom_in"):
		if Input.is_action_pressed("ui_zoom_mod"):
			target_zoom -= zoom_amount
			target_zoom = clamp(target_zoom, 0.1, 10.0)
	elif event.is_action("ui_zoom_out"):
		if Input.is_action_pressed("ui_zoom_mod"):
			target_zoom += zoom_amount
			target_zoom = clamp(target_zoom, 0.1, 10.0)
	elif event.is_action_pressed("ui_pan"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_released("ui_pan"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	$'../SketchEditor'.camera_transform = get_viewport().canvas_transform
	var c = smoothing * delta
	var output_zoom = ((target_zoom - $Camera2D.zoom.x) * c) + $Camera2D.zoom.x
	$Camera2D.zoom.x = output_zoom
	$Camera2D.zoom.y = output_zoom