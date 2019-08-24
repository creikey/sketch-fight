extends KinematicBody2D

class_name Laser

export var speed = 1000.0
export var damage = 1

const level_size = Vector2(10000, 10000)

var team: String = ""

func _physics_process(delta):
	var collision = move_and_collide(Vector2(speed, 0).rotated(rotation)*delta, false)
	if collision:
		if collision.collider is Ship:
			if collision.collider.team == team:
				pass
			else:
				collision.collider.hit(damage)
				queue_free()
		rotation = collision.normal.angle()
	if out_of_bounds(global_position.x, level_size.x) or \
		out_of_bounds(global_position.y, level_size.y):
			queue_free()

func out_of_bounds(to_check: float, axis_size: float) -> bool:
	return to_check < 0 or to_check > axis_size