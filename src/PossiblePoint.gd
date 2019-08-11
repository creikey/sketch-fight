extends Sprite

class_name PossiblePoint

var index = 0

var puck_node: Area2D = null

func _ready():
	set_process(false)

func _process(_delta):
	if puck_node == null:
		set_process(false)
		return
	if Input.is_action_pressed("ui_move"):
		global_position = puck_node.global_position

#func _input(event):
#	if event is InputEventMouseMotion and Input.is_action_pressed("ui_move") and being_hovered:
#		global_position = get_global_mouse_position()

func _on_Area2D_area_entered(area):
	if area.is_in_group("mouse_puck"):
		$AnimationPlayer.play("to_being_hovered")
		puck_node = area
		set_process(true)


func _on_Area2D_area_exited(area):
	if area.is_in_group("mouse_puck"):
		$AnimationPlayer.play("away_from_hovered")
		puck_node = null
		set_process(false)