extends Construct

const fading_amount = 0.4

var editing = false
var target_id = -1

var number_of_ships = 0 setget set_number_of_ships
var team = ""

func my_get_resource_cost():
	return 20

func setup_from_args(args: Array):
	global_position = args[0]
	modulate = args[1]
	target_id = args[2]
	team = args[3]

func _on_GenerationTimer_timeout():
	if target_id > 0 and not editing:
		Lobby.player_resources[target_id] += 1

func _on_ResourceFarmer_body_entered(body):
	if body.is_in_group("ships") and not editing:
		self.number_of_ships += 1
	elif body is Laser:
		if body.team != team:
			hit(body.damage)
			body.queue_free()

func hit(damage: float):
	get_node("LifeBar").change_health(-damage)

func _on_ResourceFarmer_body_exited(body):
	if body.is_in_group("ships") and not editing:
		self.number_of_ships -= 1

func set_number_of_ships(new_number_of_ships):
	if number_of_ships == 0 and new_number_of_ships == 1:
		$FadingTween.stop_all()
		$FadingTween.interpolate_property(self, NodePath("modulate:a"), 1.0, fading_amount, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$FadingTween.start()
	elif number_of_ships == 1 and new_number_of_ships == 0:
		$FadingTween.stop_all()
		$FadingTween.interpolate_property(self, NodePath("modulate:a"), fading_amount, 1.0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$FadingTween.start()
	number_of_ships = new_number_of_ships

func can_place() -> bool:
	if not editing:
		return true
	var area = self
	for a in area.get_overlapping_areas():
		if a.is_in_group("resource_farmers"):
			return false
	return true

func _on_LifeBar_out_of_life():
	queue_free()