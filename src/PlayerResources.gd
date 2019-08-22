extends VBoxContainer

export (PackedScene) var player_and_score_pack

func _ready():
# warning-ignore:return_value_discarded
	Lobby.connect("update_resources", self, "update_resources")
	update_resources()

func update_resources():
	for c in get_children():
		c.queue_free()
	for p in Lobby.player_resources.keys():
		var cur_player_and_score = player_and_score_pack.instance()
		var info_dict
		if p == get_tree().get_network_unique_id():
			info_dict = Lobby.my_info
		else:
			info_dict = Lobby.player_info[p]
		cur_player_and_score.get_node("Username").text = info_dict["user_name"]
		cur_player_and_score.get_node("Username").modulate = info_dict["color"]
		cur_player_and_score.get_node("Score").text = str(Lobby.player_resources[p])
		add_child(cur_player_and_score)