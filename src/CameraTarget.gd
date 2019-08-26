extends Node2D

export var smoothing = 5.0
export var zoom_amount = 0.15

var target_zoom = 1.0
var selecting = false setget set_selecting
var selecting_origin_point: Vector2 = Vector2()
var target_nodes: Array = []

func _process(delta):
	if Input.is_action_pressed("g_pan"):
		global_position = get_global_mouse_position()
	var c = smoothing * delta
	var output_zoom = ((target_zoom - $Camera2D.zoom.x) * c) + $Camera2D.zoom.x
	$Camera2D.zoom.x = output_zoom
	$Camera2D.zoom.y = output_zoom
	if selecting:
		var selection_points: Array = []
		var rect_size = get_global_mouse_position() - selecting_origin_point
		
		selection_points.append(Vector2())
		selection_points.append(Vector2(rect_size.x, 0))
		selection_points.append(rect_size)
		selection_points.append(Vector2(0, rect_size.y))
		$SelectionArea/CollisionShape2D.polygon = PoolVector2Array(selection_points)
		
		# move color rect to position
		$SelectionColorRect.rect_global_position = selecting_origin_point
		
		# size can't be negative...
		$SelectionColorRect.rect_scale.x = sign(rect_size.x)
		rect_size.x *= sign(rect_size.x)
		$SelectionColorRect.rect_scale.y = sign(rect_size.y)
		rect_size.y *= sign(rect_size.y)
		
		$SelectionColorRect.rect_size = rect_size

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
		$SelectionArea.global_position = selecting_origin_point
		$SelectionArea/CollisionShape2D.disabled = false
		$SelectionColorRect.visible = true
	elif selecting and not new_selecting: # stop selecting
		$SelectionArea/CollisionShape2D.disabled = true
		$SelectionColorRect.visible = false
	selecting = new_selecting