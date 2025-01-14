extends GridMap

func get_block(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	return get_cell_item(map_coordinate)

func destroy_block(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)

func create_block(world_coordinate, block_index):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, block_index)
