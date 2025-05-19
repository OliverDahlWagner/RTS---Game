extends TileMapLayer

@onready var terrain = $"../Terrain"

func _use_tile_data_runtime_update(coords):
	if coords in terrain.get_used_cells_by_id(0):
		return true
	else:
		return false

func _tile_data_runtime_update(coords, tile_data):
	if coords in terrain.get_used_cells_by_id(0):
		tile_data.set_navigation_polygon(0,null)
