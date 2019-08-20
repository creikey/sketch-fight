extends Node2D


func _process(_delta):
	if Input.is_action_pressed("g_pan"):
		global_position = get_global_mouse_position()