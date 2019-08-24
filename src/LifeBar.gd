extends TextureProgress

var life = 100 setget set_life

func set_life(new_life):
	life = new_life
#	value = life
	$Tween.stop_all()
	$Tween.interpolate_property(self, "value", value, new_life, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()