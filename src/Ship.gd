extends Construct
# WILL NOT WORK AS TOOL SCRIPT, checks variable on ready

class_name Ship

export var move_force = 10000
export var turn_force = 100000.0

remote var target_transform: Transform2D = Transform2D()
remote var target_linear_velocity: Vector2 = Vector2()
remote var target_angular_velocity: float = 0.0
remote var update_properties = false

#var start_position: Vector2 = Vector2()

remotesync var horizontal = 0
remotesync var vertical = 0

onready var typical_angular_drag = self.angular_damp

var network_master = false
var ship_type = "FighterShip"
var team = ""

func _ready():
#	update_ship()
	if is_network_master():
		network_master = true
	else:
		target_transform = get_transform()

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
#	if Input.is_action_just_pressed("g_reset"):
#		state.transform.origin = start_position

func _input(event):
	if network_master:
		if event.is_action("g_right") or event.is_action("g_left"):
			rset("horizontal", int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left")))
		elif event.is_action("g_up") or event.is_action("g_down"):
			rset("vertical", int(Input.is_action_pressed("g_down")) - int(Input.is_action_pressed("g_up")))

func update_ship():
	if has_node(ship_type):
		get_node(ship_type).queue_free()
	var cur_ship = load(EditingShip.ships_path + ship_type + ".tscn").instance()
	add_child(cur_ship)
	cur_ship.set_network_master(get_network_master())
	cur_ship.get_node("LifeBar").life = 100.0

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