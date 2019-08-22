extends Node2D

enum CONSTRUCT_TYPE { ship, base }

export (PackedScene) var ship_pack
export (PackedScene) var editing_ship_pack

var editing = false
var cur_construct = null
var construct_type: int = 0

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("g_open_editor"):
		if visible:
			visible = false
			editing = false
			if cur_construct:
				cur_construct.queue_free()
				cur_construct = null
			return
		visible = true
		editing = true
		construct_type = CONSTRUCT_TYPE.ship
		global_position = get_global_mouse_position()
	elif event.is_action_pressed("g_new_ship") and editing:
		if cur_construct:
			show_build_error()
			return
		# placing the construct
		match construct_type:
			CONSTRUCT_TYPE.ship:
				cur_construct = editing_ship_pack.instance()
			var unknown_type:
				printerr("Unknown construct type to place: ", unknown_type)
				show_build_error()
				return
		cur_construct.modulate.a = 0.7
		add_child(cur_construct)
	elif event.is_action_pressed("g_enter_ship") and editing:
		if not cur_construct:
			return
		match construct_type:
			CONSTRUCT_TYPE.ship:
				Lobby.transmit_object("Ship", ship_pack.resource_path, [cur_construct.global_position, Lobby.my_info["color"]])
			var unknown_type:
				printerr("Cannot transmit object: ", unknown_type)
				show_place_error()
				return
		cur_construct.queue_free()
		cur_construct = null
		visible = false
		editing = false

func show_build_error():
	$AnimationPlayer.play("error")

func show_place_error():
	pass