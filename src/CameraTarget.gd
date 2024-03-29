extends Node2D

export var smoothing = 5.0
export var zoom_amount = 0.15

var target_zoom = 1.0
var selecting = false setget set_selecting
var selecting_origin_point: Vector2 = Vector2()
var target_nodes: Array = []
var selection_rect: Rect2 = Rect2()

func _process(delta):
	if Input.is_action_pressed("g_pan") and target_nodes.size() == 0:
		global_position = get_global_mouse_position()
	if target_nodes.size() != 0:
		# correct camera position
		var average_position = Vector2()
		for t in target_nodes:
			average_position += t.global_position
		average_position = average_position/target_nodes.size()
		global_position = average_position
		
		# rotate ships on autopilot
		var average_rotation = 0.0
		for s in target_nodes:
			average_rotation += s.rotation
		average_rotation /= target_nodes.size()
		for s in target_nodes:
			s.target_squadron_rotation = average_rotation
			s.target_position = average_position
	var c = smoothing * delta
	var output_zoom = ((target_zoom - $Camera2D.zoom.x) * c) + $Camera2D.zoom.x
	$Camera2D.zoom.x = output_zoom
	$Camera2D.zoom.y = output_zoom
	if selecting:
		var selection_points: Array = []
		var rect_size = get_global_mouse_position() - selecting_origin_point
		
		# move color rect to position
		$SelectionColorRect.rect_global_position = selecting_origin_point
		
		# size can't be negative...
		var new_selecting_origin_point = selecting_origin_point
		$SelectionColorRect.rect_scale.x = sign(rect_size.x)
		new_selecting_origin_point.x += min(rect_size.x, 0)
		rect_size.x *= sign(rect_size.x)
		$SelectionColorRect.rect_scale.y = sign(rect_size.y)
		new_selecting_origin_point.y += min(rect_size.y, 0)
		rect_size.y *= sign(rect_size.y)
		
		$SelectionColorRect.rect_size = rect_size
		
		selection_rect = Rect2(new_selecting_origin_point, rect_size)

func _input(event):
	if event.is_action("ui_zoom_in"):
		target_zoom -= zoom_amount
		target_zoom = clamp(target_zoom, 0.5, 4.0)
	elif event.is_action("ui_zoom_out"):
		target_zoom += zoom_amount
		target_zoom = clamp(target_zoom, 0.5, 4.0)
	elif event.is_action_pressed("g_select_ships"):
		selecting_origin_point = get_global_mouse_position()
		self.selecting = true
	elif event.is_action_released("g_select_ships"):
		self.selecting = false

func set_selecting(new_selecting):
	if new_selecting and not selecting: # start selecting
		if target_nodes.size() != 0:
			for s in target_nodes:
				s.selected = false
		$SelectionColorRect.visible = true
	elif selecting and not new_selecting: # stop selecting
		target_nodes = []
		for s in get_tree().get_nodes_in_group("ships"):
			if selection_rect.has_point(s.global_position):
				target_nodes.append(s)
				s.selected = true
		$SelectionColorRect.visible = false
	selecting = new_selecting