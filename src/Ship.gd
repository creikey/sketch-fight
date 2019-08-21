extends RigidBody2D

class_name NetworkedRigidBody

export var move_force = 10000

remote var target_transform: Transform2D = Transform2D()
remote var target_linear_velocity: Vector2 = Vector2()
remote var target_angular_velocity: float = 0.0
remote var update_properties = false

#var start_position: Vector2 = Vector2()

remotesync var horizontal = 0
remotesync var vertical = 0

var network_master = false

func _ready():
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
	applied_force = Vector2(horizontal * move_force, vertical * move_force)
	applied_torque = 0.0
#	if Input.is_action_just_pressed("g_reset"):
#		state.transform.origin = start_position

func _input(event):
	if network_master:
		if event.is_action("g_right") or event.is_action("g_left"):
			rset("horizontal", int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left")))
		elif event.is_action("g_up") or event.is_action("g_down"):
			rset("vertical", int(Input.is_action_pressed("g_down")) - int(Input.is_action_pressed("g_up")))

func setup_from_args(args: Array):
	global_position = args[0]
	$Sprite.modulate = args[1]