extends StaticBody2D

var owner_id = 1

func _on_GenerationTimer_timeout():
	if owner_id > 0:
		Lobby.player_resources[owner_id] += 1