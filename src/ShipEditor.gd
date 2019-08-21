extends Node2D

export (PackedScene) var ship_pack
export (PackedScene) var editing_ship_pack

var editing = false
var cur_ship = null

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("g_open_editor"):
		if visible:
			visible = false
			editing = false
			if cur_ship:
				cur_ship.queue_free()
				cur_ship = null
			return
		visible = true
		editing = true
		global_position = get_global_mouse_position()
	elif event.is_action_pressed("g_new_ship") and editing:
		if cur_ship:
			return
		cur_ship = editing_ship_pack.instance()
		add_child(cur_ship)
	elif event.is_action_pressed("g_enter_ship") and editing:
		if not cur_ship:
			return
		Lobby.transmit_object("Ship", ship_pack.resource_path, [cur_ship.global_position, Lobby.my_info["color"]])
		cur_ship.queue_free()
		cur_ship = null
		visible = false
		editing = false