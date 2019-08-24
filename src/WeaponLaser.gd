extends Module

export (PackedScene) var laser_pack

const laser_damage = 4.0
const laser_speed = 4000.0

# warning-ignore:unused_argument
func my_target_click(in_target: Vector2):
	pass

# warning-ignore:unused_argument
func my_fire(ship_rotation: float, ship_position: Vector2, team: String, ship: PhysicsBody2D):
	var cur_laser: Laser = laser_pack.instance()
	get_node("/root/World/Lasers").add_child(cur_laser)
	cur_laser.rotation = ship_rotation
	cur_laser.damage = laser_damage
	cur_laser.speed = laser_speed
	cur_laser.global_position = global_position
	cur_laser.team = team
	cur_laser.add_collision_exception_with(ship)
	$AnimationPlayer.play("fire")