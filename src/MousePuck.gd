extends Control

class_name MousePuck

export (Color) var color = Color()
export (int) var size = 6.0

var out_of_editing_pad: bool = false setget set_out_of_editing_pad

func _ready():
	self.size = size
	self.out_of_editing_pad = true

func _physics_process(delta):
	rect_global_position = get_global_mouse_position()
	$MirroredArea.global_position = get_mirrored_pos(rect_global_position)
#	print(get_mirrored_pos(rect_global_position) - rect_global_position)
	update()

func _draw():
	draw_circle(Vector2(), size, color)
#	print(rect_global_position)
	draw_circle(get_mirrored_pos(rect_global_position) - rect_global_position, size, color)


func _on_Area2D_area_exited(area):
	if area.name == "EditingPad":
		self.out_of_editing_pad = true

func _on_Area2D_area_entered(area):
	if area.name == "EditingPad":
		self.out_of_editing_pad = false

func set_out_of_editing_pad(new_out_of_editing_pad):
	out_of_editing_pad = new_out_of_editing_pad
	if out_of_editing_pad:
		$'../AnimationPlayer'.play("out_of_editing_pad")
	else: 
		$'../AnimationPlayer'.play("into_editing_pad")

static func get_mirrored_pos(in_pos: Vector2) -> Vector2:
	return Vector2(1920 - in_pos.x, in_pos.y)