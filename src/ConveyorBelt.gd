extends Sprite

export var direction = 1.0

func _process(delta):
	region_rect.position += Vector2(20, 20)*delta*direction