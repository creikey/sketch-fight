extends Resource

signal fighter_autopilot_changed(current_value)

export var fighter_autopilot: bool = false setget set_fighter_autopilot

func set_fighter_autopilot(new_fighter_autopilot):
	fighter_autopilot = new_fighter_autopilot
	emit_signal("fighter_autopilot_changed", fighter_autopilot)