extends Area2D

export var resource_yield = 10.0

onready var initial_a = $Sprite.modulate.a

func _on_ResourceBlock_body_entered(body):
	if body is Ship and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("resources_gotten")
		Lobby.player_resources[body.get_network_master()] += resource_yield