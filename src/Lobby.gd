extends Node

signal update_lobby(player_info, my_info)
signal update_resources

# Player info, associate ID to data
var player_info = {}
# sync different positions for each character
#var starting_positions = {}
# Info we send to other players
var my_info = { user_name = "server", color = Color8(255, 0, 0) }

var target_server_info = {
	ip = "127.0.0.1",
	port = "5563"
}

var number_of_ships_per_id = {}

var player_resources = {}
onready var player_resource_timer: Timer = null
func _on_player_resource_timer_timeout():
	if get_tree().paused:
		return
	emit_signal("update_resources")

var upnp: UPNP = null
var forwarded_port = -1

# Connect all functions

func _ready():
#	pause_mode = Node.PAUSE_MODE_PROCESS
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")
# warning-ignore:return_value_discarded
	connect("tree_exiting", self, "_on_tree_exiting")
	player_resource_timer = Timer.new()
	player_resource_timer.wait_time = 0.5
	player_resource_timer.one_shot = false
	player_resource_timer.autostart = false
	player_resource_timer.stop()
# warning-ignore:return_value_discarded
	player_resource_timer.connect("timeout", self, "_on_player_resource_timer_timeout")
	add_child(player_resource_timer)

func start_server(port):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, 4)
	get_tree().set_network_peer(peer)
	target_server_info["port"] = str(port)
	if upnp != null:
		target_server_info["ip"] = upnp.query_external_address()
	else:
		target_server_info["ip"] = "127.0.0.1"

func join_server(port, ip):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)


func _on_tree_exiting():
	if upnp != null:
# warning-ignore:return_value_discarded
		upnp.delete_port_mapping(forwarded_port)

func _player_connected(id):
	var my_id = get_tree().get_network_unique_id()
	# tell new player about myself
	print("Relaying my info ", my_info)
	rpc_id(id, "register_player", my_id, my_info)
	emit_signal("update_lobby", player_info, my_info)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.
	player_resources.erase(id)
	if get_node("/root").has_node("World"):
		get_node("/root/World/Ships/" + str(id)).queue_free()
		get_node("/root/World/ResourceFarmers/" + str(id)).queue_free()
	emit_signal("update_resources")
	emit_signal("update_lobby", player_info, my_info)

func _connected_ok():
	# Only called on clients, not server.
	get_node("/root/LobbyScene/UI").goto_main_menu()
	print("connected ok")

func _server_disconnected():
	print("Server disconnected")
	get_tree().paused = true
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://ServerQuit.tscn")
	pass # Server kicked us; show error and abort.

func _connected_fail():
	print("Failed to connect")
	pass # Could not even connect to server; abort.

remote func register_player(id, info):
	print("Registering player ", info)
	# Store the info
	player_info[id] = info
	# Call function to update lobby UI here
	emit_signal("update_lobby", player_info, my_info)

remotesync func preconfigure_game():
	var my_peer_id = get_tree().get_network_unique_id()
	
	# unique starting positions
#	var player_id_array = player_info.keys()
#	player_id_array.append(my_peer_id)
#	player_id_array.sort()
#	var cur_start_position = Vector2()
#	for p in player_id_array:
#		starting_positions[p] = cur_start_position
#		cur_start_position.x += 100
#	print(starting_positions)
	
	var world = load("res://World.tscn").instance()
	get_node("/root").add_child(world)
	get_node("/root/World/Environment").set_network_master(1)
	
	
	
#	var player_pack = preload("res://Player.tscn")
#	var my_player = player_pack.instance()
#	my_player.set_name(str(my_peer_id))
#	my_player.set_network_master(my_peer_id)
#	my_player.get_node("ColorRect").color = my_info["color"]
#	my_player.get_node("NametagLabel").text = my_info["user_name"]
#	my_player.start_position = starting_positions[my_peer_id]
#	my_player.global_position = starting_positions[my_peer_id]
#	get_node("/root/World/Players").add_child(my_player)
#
#	cur_start_position.x += 100
	
#	for p in player_info:
#		var cur_player = player_pack.instance()
#		cur_player.set_name(str(p))
#		cur_player.set_network_master(p)
#		cur_player.get_node("ColorRect").color = player_info[p]["color"]
#		cur_player.get_node("NametagLabel").text = player_info[p]["user_name"]
#		cur_player.start_position = starting_positions[p]
#		cur_player.global_position = starting_positions[p]
#		get_node("/root/World/Players").add_child(cur_player)
#		cur_start_position.x += 100
	
	player_resources[my_peer_id] = 0
	for p in player_info.keys():
		player_resources[p] = 0
	player_resource_timer.start()
	get_node("/root/LobbyScene").queue_free()
	if my_peer_id == 1:
		pass
	else:
		rpc_id(1, "done_preconfiguring", my_peer_id)

var players_done = []
remote func done_preconfiguring(who):
	assert(get_tree().is_network_server())
	assert(who in player_info)
	assert(not who in players_done)
	
	players_done.append(who)
	if players_done.size() == player_info.size() + 1: # account for server
		rpc("post_configure_game")

remote func post_configure_game():
	pass

func add_categorical_node(root_node_name: String, master_id: int, object: Node):
	var parent_parent_node_name = "/root/World/" + root_node_name + "s"
	var parent_node_name = str(master_id)
	if not get_node(parent_parent_node_name).has_node(parent_node_name):
		var cur_parent_node = Node2D.new()
		cur_parent_node.set_name(parent_node_name)
		get_node(parent_parent_node_name).add_child(cur_parent_node)
	get_node(parent_parent_node_name + "/" + parent_node_name).add_child(object)

# make sure to free node ship after this is done
# must have node2d acting as a layer with same name as input node + 's'
# object must have a function called 'setup_from_args' that takes the array and
#	duplicates its state
func transmit_object(object_name: String, object_pack_path: String, arguments: Array): # called when spawning new object
	var my_peer_id = get_tree().get_network_unique_id()
	if not number_of_ships_per_id.has(my_peer_id):
		number_of_ships_per_id[my_peer_id] = 0
	number_of_ships_per_id[my_peer_id] += 1
	
	var my_object = load(object_pack_path).instance()
	my_object.set_name(str(my_peer_id) + object_name + str(number_of_ships_per_id[my_peer_id]))
	my_object.set_network_master(my_peer_id)
	my_object.setup_from_args(arguments)
	add_categorical_node(object_name, my_peer_id, my_object)
#	get_node("/root/World/" + object_name + "s").add_child(my_object)
	
	rpc("receive_object", object_pack_path, arguments, my_peer_id, object_name)

remote func receive_object(object_pack_path: String, arguments: Array, master_id: int, root_node_name: String): # called on everybody else to show new object
	if not number_of_ships_per_id.has(master_id):
		number_of_ships_per_id[master_id] = 0
	number_of_ships_per_id[master_id] += 1
	
	var cur_object = load(object_pack_path).instance()
	
	cur_object.set_name(str(master_id) + root_node_name + str(number_of_ships_per_id[master_id]))
	cur_object.set_network_master(master_id)
	cur_object.setup_from_args(arguments)
	add_categorical_node(root_node_name, master_id, cur_object)
#	var parent_parent_node_name = "/root/World/" + root_node_name + "s"
#	var parent_node_name = str(master_id)
#	if not parent_parent_node_name.has(parent_node_name):
#		var cur_parent_node = Node2D.new()
#		cur_parent_node.set_name(parent_node_name)
#		parent_parent_node_name.add_child(cur_parent_node)
#	get_node(parent_parent_node_name + "/" + parent_node_name).add_child(cur_object)