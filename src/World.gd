extends Node2D

const game_state = preload("res://game_state.tres")

func _ready():
	game_state.connect("gamestate_update", self, "on_gamestate_update")

func on_gamestate_update():
	# ensure everybody has built something
	for p in game_state.get_player_ids():
		if not game_state.get_player_gamestate(p)[1]: # somebody hasn't built something yet
			return
	
	# assign a winner position to the one with ships while everybody else doesn't have any
	var won_id = -1
	for p in game_state.get_player_ids():
		if game_state.get_player_gamestate(p)[0] > 0: # this player has active ships
			if won_id > 0: # another player has ships too
				return
			won_id = p

	var player_name: String
	if won_id == get_tree().get_network_unique_id():
		player_name = Lobby.my_info["user_name"]
	else:
		player_name = Lobby.player_info[won_id]["user_name"]
	print("Player ", player_name, " has won!")
	game_state.won_player_name = player_name
	get_tree().change_scene("res://PlayerWon.tscn")