extends ColorRect

class_name ConstructEditor

enum CONSTRUCT_TYPE { ship, resource_block }

export (PackedScene) var ship_pack
export (PackedScene) var resource_farmer_pack
export (PackedScene) var editing_ship_pack
export (PackedScene) var editing_resource_farmer_pack

var editing = false
var cur_construct: Construct = null
var construct_type: int = 0

var resource_consumption = 0 setget set_resource_consumption

func _ready():
	visible = false

func not_enough_resources():
	return resource_consumption >= Lobby.player_resources[get_tree().get_network_unique_id()]

func _input(event):
	if event.is_action_pressed("g_open_editor"):
		if visible:
			visible = false
			editing = false
			if cur_construct:
				cur_construct.queue_free()
				cur_construct = null
			return
		$Snapper/CollisionShape2D.disabled = true
		$SnapperTwean.stop_all()
		visible = true
		editing = true
		construct_type = CONSTRUCT_TYPE.ship
		rect_global_position = get_global_mouse_position() - rect_size/2
		$Snapper/CollisionShape2D.disabled = false
	elif event.is_action_pressed("g_enter_ship") and editing:
		if not cur_construct:
			return
		if not_enough_resources():
			show_place_error()
			return
		# placing construct in world
		$Snapper/CollisionShape2D.disabled = true
		match construct_type:
			CONSTRUCT_TYPE.ship:
				Lobby.transmit_object("Ship", ship_pack.resource_path, resource_consumption, [cur_construct.global_position, "FighterShip", Lobby.my_info["color"], cur_construct.get_module_arg(), Lobby.my_info["team"]])
			CONSTRUCT_TYPE.resource_block:
				if not cur_construct.can_place():
					show_place_error()
					return
				Lobby.transmit_object("ResourceFarmer", resource_farmer_pack.resource_path, resource_consumption, [cur_construct.global_position, Lobby.my_info["color"], get_tree().get_network_unique_id(), Lobby.my_info["team"]])
			_:
				printerr("Cannot transmit object: ", construct_type)
				show_place_error()
				return
		cur_construct.queue_free()
		cur_construct = null
		visible = false
		editing = false

func _gui_input(event):
	if event.is_action_pressed("g_new_ship") and editing:
		if cur_construct:
			show_build_error()
			return
		# creating the construct
		$Snapper/CollisionShape2D.disabled = true
		match construct_type:
			CONSTRUCT_TYPE.ship:
				cur_construct = editing_ship_pack.instance()
			CONSTRUCT_TYPE.resource_block:
				cur_construct = editing_resource_farmer_pack.instance()
			_:
				printerr("Unknown construct type to place: ", construct_type)
				show_build_error()
				return
		ensure_editing(cur_construct)
		cur_construct.modulate.a = 0.7
		cur_construct.position = rect_size/2
		add_child(cur_construct)
		self.resource_consumption = cur_construct.my_get_resource_cost()
# warning-ignore:return_value_discarded
		cur_construct.connect("resource_cost_changed", self, "resource_cost_changed")
	

func resource_cost_changed(new_resource_cost):
	self.resource_consumption = new_resource_cost

func ensure_editing(node):
	if node.get("editing") != null:
		node.editing = true

func show_build_error():
	$AnimationPlayer.play("error")

func show_place_error():
	show_build_error()

func _on_Snapper_body_entered(body):
	if body.is_in_group("constructable"):
		construct_type = body.construct_type
		$SnapperTwean.stop_all()
		$SnapperTwean.interpolate_property(self, "rect_position", rect_position, body.global_position - rect_size/2, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$SnapperTwean.start()

func set_resource_consumption(new_resource_consumption):
	resource_consumption = new_resource_consumption
	$PanelContainer/MarginContainer/HBoxContainer/ConsumptionLabel.text = str(new_resource_consumption)
	if not_enough_resources():
		$PanelContainer/MarginContainer/HBoxContainer/ConsumptionLabel.modulate = Color(1, 0, 0)
	else:
		$PanelContainer/MarginContainer/HBoxContainer/ConsumptionLabel.modulate = Color(1, 1, 1)