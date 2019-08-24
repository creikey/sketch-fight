extends Area2D

export var speed = 1000.0
export var damage = 1

func _process(delta):
	global_position += Vector2(speed, 0).rotated(rotation)*delta

func _on_Laser_body_entered(body):
	if body is Ship:
		body.hit(damage)