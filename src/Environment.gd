extends Node2D

export (PackedScene) var resource_block_pack
export var resource_block_width = 400.0
export var resource_density = 0.2
export var stage_size = 10000

func _ready():
	var cur_spawn_location = Vector2()
	while cur_spawn_location.y < stage_size:
		while cur_spawn_location.x < stage_size:
			spawn_resource_block(cur_spawn_location)
			cur_spawn_location.x += rand_range(resource_block_width, resource_density*stage_size)
		cur_spawn_location.y += rand_range(resource_block_width, resource_density*stage_size)