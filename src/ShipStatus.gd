extends VBoxContainer

export var off_color = Color()
export var on_color = Color()

const control_state = preload("res://control_state.tres")

func _ready():
	update_status_label(control_state.fighter_autopilot)
	control_state.connect("fighter_autopilot_changed", self, "update_status_label")

func _input(event):
	if event.is_action_pressed("g_toggle_autopilot"):
		control_state.fighter_autopilot = !(control_state.fighter_autopilot)

func update_status_label(new_value):
	if new_value:
		$AutopilotHBoxContainer/StatusLabel.text = "On"
		$AutopilotHBoxContainer/StatusLabel.modulate = on_color
	else:
		$AutopilotHBoxContainer/StatusLabel.text = "Off"
		$AutopilotHBoxContainer/StatusLabel.modulate = off_color