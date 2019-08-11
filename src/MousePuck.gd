extends Control

export (Color) var color = Color()
export (int) var size = 6.0

var out_of_editing_pad: bool = false setget set_out_of_editing_pad

func _ready():
	self.size = size

func _process(delta):
	rect_global_position = get_viewport().get_mouse_position()

func _draw():
	draw_circle(Vector2(), size, color)


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