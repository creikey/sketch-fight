extends ProgressBar

signal out_of_life

var life = 100 setget set_life

var position_offset: Vector2 = Vector2()

func _ready():
	position_offset = ($Position2D.global_position - get_parent().global_position) - rect_size/2
	var before_rect_size = rect_size
	set_as_toplevel(true)
	rect_size = before_rect_size

func _process(delta):
	rect_global_position = get_parent().global_position + position_offset

func change_health(change_amount: float):
	self.life += change_amount

func set_life(new_life):
	life = new_life
	$Tween.stop_all()
	$Tween.interpolate_property(self, "value", value, new_life, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.3, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed():
	if not value >= 0.001:
		emit_signal("out_of_life")