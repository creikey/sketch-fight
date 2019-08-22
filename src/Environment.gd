extends Node2D

export (PackedScene) var resource_block_pack
export var resource_block_width = 700.0
export var resource_density = 0.3
export var stage_size = 10000

func _ready():
	randomize()
	if is_network_master():
		var number_of_resource_blocks = 0
		var cur_spawn_location = Vector2(resource_block_width, resource_block_width)
		while cur_spawn_location.y < stage_size - resource_block_width:
			while cur_spawn_location.x < stage_size - resource_block_width:
				var output_rotation = rand_range(0, 360)
				spawn_resource_block(cur_spawn_location, number_of_resource_blocks, output_rotation)
				rpc("spawn_resource_block", cur_spawn_location, number_of_resource_blocks,output_rotation)
				number_of_resource_blocks += 1
				cur_spawn_location.x += resource_density*stage_size
			cur_spawn_location.y += resource_density*stage_size
			cur_spawn_location.x = resource_block_width

remote func spawn_resource_block(spawn_location: Vector2, cur_count: int, rot: float):
	var cur_resource_block = resource_block_pack.instance()
	cur_resource_block.name = str(cur_count)
	$ResourceBlocks.add_child(cur_resource_block)
	cur_resource_block.rotation_degrees = rot
	cur_resource_block.global_position = spawn_location