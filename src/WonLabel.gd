extends Label

func _process(delta):
	text = "Player " + preload("res://game_state.tres").won_player_name + " has won!"