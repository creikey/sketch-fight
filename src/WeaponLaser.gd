extends Module

export (PackedScene) var laser_pack

const laser_damage = 4.0
const laser_speed = 800.0

# warning-ignore:unused_argument
func my_target_click(in_target: Vector2):
	pass

func my_fire(ship_rotation: float, ship_position: Vector2):
	var cur_laser = laser_pack.instance()
	get_node("/root/World/Lasers").add_child(cur_laser)
	cur_laser.rotation = ship_rotation
	cur_laser.damage = laser_damage
	cur_laser.speed = laser_speed
	cur_laser.global_position = ship_position
	$AnimationPlayer.play("fire")