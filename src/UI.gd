extends CanvasLayer

const SAVE_SETTINGS_TIME = 1.0

var cur_settings_save_time = 0.0


func _ready():
	load_settings()

func _process(delta):
	cur_settings_save_time += delta
	if cur_settings_save_time >= SAVE_SETTINGS_TIME:
		save_settings()
		cur_settings_save_time = 0.0

func goto_main_menu():
	$PanelContainer/VBoxContainer/HBoxContainer2.visible = false
	$PanelContainer/VBoxContainer/Port.visible = false
	$PanelContainer/VBoxContainer/JoinCode.visible = false
	$PanelContainer/VBoxContainer/HBoxContainer/JoinServerButton.visible = false
	$PanelContainer/VBoxContainer/HBoxContainer/StartServerButton.visible = false
	$PanelContainer/VBoxContainer/UPNPButton.visible = false
	Lobby.my_info["user_name"] = $PanelContainer/VBoxContainer/HBoxContainer2/Username.text
	Lobby.my_info["color"] = $PanelContainer/VBoxContainer/HBoxContainer2/Panel/HBoxContainer/ColorPickerButton.color
	$PanelContainer/VBoxContainer/UpdateHBoxContainer/NewUsername.text = Lobby.my_info["user_name"]
	$PanelContainer/VBoxContainer/UpdateHBoxContainer/Panel/HBoxContainer/ColorPickerButton.color = Lobby.my_info["color"]
	$PanelContainer/VBoxContainer/UpdateHBoxContainer.visible = true
	$PanelContainer/VBoxContainer/UPNPLog.visible = false
	$PanelContainer/VBoxContainer/HBoxContainer4.visible = false

func _on_JoinServerButton_pressed():
	goto_main_menu()
	var target_dict = parse_json(Marshalls.base64_to_utf8($PanelContainer/VBoxContainer/JoinCode.text))
	if typeof(target_dict) != TYPE_DICTIONARY or not target_dict.has("ip") or not target_dict.has("port"):
		printerr("Incorrectly formatted join code")
	# print(target_dict)
	Lobby.join_server(int(target_dict["port"]), target_dict["ip"])
	Lobby.emit_signal("update_lobby", Lobby.player_info, Lobby.my_info)

func _on_StartServerButton_pressed():
	goto_main_menu()
	$PanelContainer/VBoxContainer/HBoxContainer/StartGameButton.visible = true
	$PanelContainer/VBoxContainer/HBoxContainer/CopyJoinCodeButton.visible = true
	Lobby.start_server(int($PanelContainer/VBoxContainer/Port.text))
	Lobby.emit_signal("update_lobby", Lobby.player_info, Lobby.my_info)

func _on_UPNPButton_pressed():
	if Lobby.upnp != null:
		return
	var upnp_log = $PanelContainer/VBoxContainer/UPNPLog
	upnp_log.visible = true
	var port = int($PanelContainer/VBoxContainer/Port.text)
	Lobby.upnp = UPNP.new()
	Lobby.forwarded_port = port
	var discover_return_code = Lobby.upnp.discover(2000, 2, "InternetGatewayDevice")
	var port_mapping_return_code = Lobby.upnp.add_port_mapping(port)
	upnp_log.text = "Discover: " + str(discover_return_code) + ", Port Map: " + str(port_mapping_return_code) + " | "
	if discover_return_code == 0 and port_mapping_return_code == 0:
		upnp_log.text += "UPNP successful! Port forwarded! | "
		upnp_log.text += "IP: " + str(Lobby.upnp.query_external_address())
	else:
		upnp_log.text += "UPNP failed :(, relay code to developer"

func save_settings():
	var settings_dict = {
		"username": $PanelContainer/VBoxContainer/HBoxContainer2/Username.text,
		"color": $PanelContainer/VBoxContainer/HBoxContainer2/Panel/HBoxContainer/ColorPickerButton.color,
		"port": $PanelContainer/VBoxContainer/Port.text,
		"join_code": $PanelContainer/VBoxContainer/JoinCode.text
	}
	var json_settings = to_json(settings_dict)
	var settings_file: File = File.new()
# warning-ignore:return_value_discarded
	settings_file.open("user://settings.json", File.WRITE)
	settings_file.store_string(json_settings)
	settings_file.close()

func load_settings():
	var settings_file: File = File.new()
	var dir = Directory.new()
	if not dir.file_exists("user://settings.json"): # if file doesn't exist return
		return
# warning-ignore:return_value_discarded
	settings_file.open("user://settings.json", File.READ)
	var settings_dict = parse_json(settings_file.get_as_text())
	if typeof(settings_dict) == TYPE_DICTIONARY:
		$PanelContainer/VBoxContainer/HBoxContainer2/Username.text = settings_dict["username"]
		var color_array = settings_dict["color"].split(",")
		var resultant_color = Color()
		resultant_color.r = float(color_array[0])
		resultant_color.g = float(color_array[1])
		resultant_color.b = float(color_array[2])
		resultant_color.a = float(color_array[3])
		$PanelContainer/VBoxContainer/HBoxContainer2/Panel/HBoxContainer/ColorPickerButton.color = resultant_color
		$PanelContainer/VBoxContainer/Port.text = settings_dict["port"]
		$PanelContainer/VBoxContainer/JoinCode.text = settings_dict["join_code"]
	else:
		printerr("Wrong type from loaded settings file. Expected dict, type is: ", typeof(settings_dict))
		dir.remove("user://settings.json")
	settings_file.close()


func _on_UI_tree_exiting():
	save_settings()


func _on_StartGameButton_pressed():
	assert(get_tree().get_network_unique_id() == 1)
	Lobby.rpc("preconfigure_game")


func _on_CopyJoinCodeButton_pressed():
	OS.clipboard = Marshalls.utf8_to_base64(to_json(Lobby.target_server_info))

func _on_ClientCheckBox_pressed():
	$PanelContainer/VBoxContainer/JoinCode.visible = true
	$PanelContainer/VBoxContainer/Port.visible = false
	$PanelContainer/VBoxContainer/HBoxContainer/JoinServerButton.visible = true
	$PanelContainer/VBoxContainer/HBoxContainer/StartServerButton.visible = false
	$PanelContainer/VBoxContainer/UPNPButton.visible = false


func _on_ServerCheckBox_pressed():
	$PanelContainer/VBoxContainer/JoinCode.visible = false
	$PanelContainer/VBoxContainer/Port.visible = true
	$PanelContainer/VBoxContainer/HBoxContainer/JoinServerButton.visible = false
	$PanelContainer/VBoxContainer/HBoxContainer/StartServerButton.visible = true
	$PanelContainer/VBoxContainer/UPNPButton.visible = true
