extends RigidBody2D

export var move_force = 1000

remote var target_transform: Transform2D = Transform2D()

var start_position: Vector2 = Vector2()

remote var horizontal = 0
remote var vertical = 0

func _ready():
	start_position = global_position
	if is_network_master():
		pass
	else:
#		set_mode(RigidBody2D.MODE_KINEMATIC)
		target_transform = get_transform()

func _integrate_forces(state: Physics2DDirectBodyState):
#	if not is_network_master():
##		print("Setting transform to ", target_transform.origin)
#		state.transform = target_transform
#		return
	if is_network_master():
		horizontal = int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left"))
		vertical = int(Input.is_action_pressed("g_down")) - int(Input.is_action_pressed("g_up"))
		rset_unreliable("horizontal", horizontal)
		rset_unreliable("vertical", vertical)
#	print(Vector2(horizontal * move_force, vertical * move_force))
#	print(linear_velocity)
	applied_force = Vector2(horizontal * move_force, vertical * move_force)
	applied_torque = 0.0
	if Input.is_action_just_pressed("g_reset"):
		state.transform.origin = start_position
#	rset_unreliable("target_transform", state.transform)


#func _physics_process(delta):
#	if is_network_master():
#		move_and_collide(move_speed * Vector2(int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left")), -int(Input.is_action_pressed("g_up")) + int(Input.is_action_pressed("g_down")))*delta)
#		rset_unreliable("target_position", global_position)
#	else:
#		move_and_collide(target_position - global_position)
