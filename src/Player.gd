extends RigidBody2D

export var move_force = 1000
export var sync_time = 0.2

remote var target_transform: Transform2D = Transform2D()
remote var update_transform = false

var start_position: Vector2 = Vector2()
var cur_sync_time = 0.0

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
#		cur_sync_time += state.step
#		if cur_sync_time >= sync_time:
		rset_unreliable("target_transform", state.transform)
		rset_unreliable("update_transform", true)
#			cur_sync_time = 0.0
#	print(Vector2(horizontal * move_force, vertical * move_force))
#	print(linear_velocity)
	if update_transform:
		update_transform = false
		state.transform = target_transform
	applied_force = Vector2(horizontal * move_force, vertical * move_force)
	applied_torque = 0.0
	if Input.is_action_just_pressed("g_reset"):
		state.transform.origin = start_position
	$NametagLabel.rect_rotation = -rad2deg(state.transform.get_rotation())
#	rset_unreliable("target_transform", state.transform)


#func _physics_process(delta):
#	if is_network_master():
#		move_and_collide(move_speed * Vector2(int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left")), -int(Input.is_action_pressed("g_up")) + int(Input.is_action_pressed("g_down")))*delta)
#		rset_unreliable("target_position", global_position)
#	else:
#		move_and_collide(target_position - global_position)
