extends Construct
# WILL NOT WORK AS TOOL SCRIPT, checks variable on ready

class_name Ship

enum AUTOPILOT { fly, reposition }

const control_state = preload("res://control_state.tres")

export var move_force: float = 10000
export var turn_force = 50000.0

remote var target_transform: Transform2D = Transform2D()
remote var target_linear_velocity: Vector2 = Vector2()
remote var target_angular_velocity: float = 0.0
remote var update_properties = false

#var start_position: Vector2 = Vector2()

remotesync var horizontal: int = 0
remotesync var vertical: int = 0

onready var typical_angular_drag = self.angular_damp

var network_master = false
var ship_type = "FighterShip"
var team = ""
var target_squadron_rotation: float = 0.0
var target_position: Vector2 = Vector2()
var autopilot_state = AUTOPILOT.fly

var selected = false setget set_selected

func _ready():
#	update_ship()
	set_physics_process(control_state.fighter_autopilot)
# warning-ignore:return_value_discarded
	control_state.connect("fighter_autopilot_changed", self, "_on_fighter_autopilot_changed")
	if is_network_master():
		network_master = true
	else:
		target_transform = get_transform()

func _on_fighter_autopilot_changed(new_value):
#	print(new_value)
	set_physics_process(new_value)

# warning-ignore:unused_argument
func _physics_process(delta):
	if not selected and network_master:
		return
	var horizontal_input = get_horizontal_input()
	var vertical_input = get_vertical_input()
	
	match autopilot_state:
		AUTOPILOT.fly:
			if target_position.distance_to(global_position) >= 200: # repositioning mode
				autopilot_state = AUTOPILOT.reposition
			
			if abs(target_squadron_rotation - rotation) > 0.2:
				if rotation < target_squadron_rotation:
					horizontal_input = 1
				else:
					horizontal_input = -1
			
			if has_node(ship_type):
				var collider = get_node(ship_type).get_node("LookAheadRaycast2D").get_collider()
				if collider:
					if get_node(ship_type).get_node("LookRightRaycast2D").is_colliding():
						horizontal_input = -1
					else:
						horizontal_input = 1
		AUTOPILOT.reposition:
			if target_position.distance_to(global_position) <= 150: # with squadron again
				autopilot_state = AUTOPILOT.fly
	
	rset_unreliable("horizontal", horizontal_input)
	rset_unreliable("vertical", vertical_input)

#func _process(_delta):
#	$NametagLabel.rect_rotation = -rotation_degrees

func _integrate_forces(state: Physics2DDirectBodyState):
	if network_master:
		rset_unreliable("target_transform", state.transform)
		rset_unreliable("target_linear_velocity", state.linear_velocity)
		rset_unreliable("target_angular_velocity", state.angular_velocity)
		rset_unreliable("update_properties", true)
	if update_properties:
		update_properties = false
		state.transform = target_transform
		state.linear_velocity = target_linear_velocity
		state.angular_velocity = target_angular_velocity
#	applied_force = Vector2(horizontal * move_force, vertical * move_force)
	self.applied_force = Vector2(-vertical * move_force, 0).rotated(state.transform.get_rotation())
	if horizontal == 0:
		self.angular_damp = typical_angular_drag
	else:
		self.angular_damp = -1
	self.applied_torque = horizontal * turn_force
#	print(self.applied_torque)
#	if Input.is_action_just_pressed("g_reset"):
#		state.transform.origin = start_position

func _input(event):
	if network_master and selected and not control_state.fighter_autopilot:
		if event.is_action("g_right") or event.is_action("g_left"):
			rset("horizontal", get_horizontal_input())
		elif event.is_action("g_up") or event.is_action("g_down"):
			rset("vertical", get_vertical_input())

func get_horizontal_input() -> int:
	return int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left"))

func get_vertical_input() -> int:
	return int(Input.is_action_pressed("g_down")) - int(Input.is_action_pressed("g_up"))

func update_ship():
	if has_node(ship_type):
		get_node(ship_type).queue_free()
	var cur_ship = load(EditingShip.ships_path + ship_type + ".tscn").instance()
	add_child(cur_ship)
	self.selected = false
	cur_ship.set_network_master(get_network_master())
	cur_ship.get_node("LifeBar").life = 100.0
	cur_ship.to_battle_mode()

func setup_from_args(args: Array):
	global_position = args[0]
	ship_type = args[1]
#	print(args[3])
	update_ship()
	get_node(ship_type).get_node("Sprite").modulate = args[2]
	get_node(ship_type).setup_from_one_arg(args[3])
	team = args[4]

func dead():
	queue_free()

func hit(damage: float):
	if has_node(ship_type):
		get_node(ship_type).get_node("LifeBar").change_health(-damage)

func set_selected(new_selected):
	selected = new_selected
	if has_node(ship_type):
		get_node(ship_type).get_node("SelectedRing").visible = selected