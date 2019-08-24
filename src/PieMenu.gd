tool
extends Control

class_name PieMenu

signal option_chosen(name_of_option)

# All children must be controls

export var control_distance = 100.0 setget set_control_distance
export var center_thickness = 50.0
export var center_size = 200.0
export var center_color = Color()
export var target_color = Color()
export var center_resolution = 32
export var label_text = "test" setget set_label_text
export var text_distance = 100 setget set_text_distance
export var delete_on_hide = false

var cur_control: Control = null
var hiding = false

func _ready():
	if not Engine.editor_hint:
		set_process(false)
		visible = false
#		show()
	else:
		show()
		set_process(true)

func _process(_delta):
	if visible:
		update()

func _input(event):
	if hiding:
		return
	if event is InputEventMouseMotion:
		update()
	elif event.is_action_pressed("ui_click") and cur_control != null:
		accept_event()
		emit_signal("option_chosen", cur_control.name)
		hide()
	if cur_control != null:
		if cur_control.has_method("_gui_input"):
			cur_control._gui_input(event)

func get_circle_points(resolution: float, radius: float, offset: float, missing_amount: float) -> Array:
	var to_return = []
	var cur_angle = offset
	var segment_length = (2*PI)/resolution
	while cur_angle < ((2*PI + (segment_length)*2) - missing_amount*(2*PI)) + offset:
		to_return.append(Vector2(radius, 0).rotated(cur_angle))
		cur_angle += (2*PI)/resolution
	return to_return

func _draw():
	# main circle
	draw_polyline(get_circle_points(center_resolution, center_size, 0.0, 0), center_color, center_thickness, true)
	
	var control_children = []
	for c in get_children():
		if c is Control and c.name != "Label":
			control_children.append(c)
	var mouse_angle = rect_global_position.angle_to_point(get_global_mouse_position())
	if not Engine.editor_hint:
		# selection arc
		draw_polyline(get_circle_points(center_resolution, center_size, mouse_angle + PI - 0.5*0.2*2*PI, 0.8), target_color, center_thickness, true)
		var highest_dot_product = 0.0
		var selected_control: Control = null
		for b in control_children:
			var local_mouse_position: Vector2 = get_global_mouse_position() - rect_global_position
			var cur_dot_product = max(local_mouse_position.dot(b.rect_position + b.rect_size/2), 0.0)
			if cur_dot_product > highest_dot_product:
				selected_control = b
				highest_dot_product = cur_dot_product
		if selected_control != null:
			cur_control = selected_control
			if cur_control.focus_mode != FOCUS_NONE:
				cur_control.grab_focus()
	
	var cur_angle = 0.0
	var cur_control_child = 0
	while cur_control_child < control_children.size():
		var cur_position = Vector2(0, -control_distance).rotated(cur_angle)
		var cur_control: Control = control_children[cur_control_child]
		cur_control.rect_position = cur_position - cur_control.rect_size/2
		cur_angle += (2*PI)/control_children.size()
		cur_control_child += 1

func show():
	visible = true
	$AnimationPlayer.play("show")

func hide():
	hiding = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$AnimationPlayer.play("hide")

func set_label_text(new_label_text):
	label_text = new_label_text
	if has_node("Label"):
		$Label.text = new_label_text

func set_text_distance(new_text_distance):
	text_distance = new_text_distance
	if has_node("Label"):
		$Label.rect_position.y = -new_text_distance

func set_control_distance(new_control_distance):
	control_distance = new_control_distance
	update()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		visible = false
		if delete_on_hide:
			queue_free()