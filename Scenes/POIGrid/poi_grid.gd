extends TileMapLayer
class_name POIGrid

@export var visible_boundary: bool = true

const tile_free: Vector2i = Vector2i(0,0)
const tile_occupied: Vector2i = Vector2i(1,0)
	
func get_surrounding_cells_2(coords: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = [
		coords + Vector2i(2,0),
		coords + Vector2i(1,1),
		coords + Vector2i(0,2),
		coords + Vector2i(-1,2),
		coords + Vector2i(-2,2),
		coords + Vector2i(-2,1),
		coords + Vector2i(-2,0),
		coords + Vector2i(-1,-1),
		coords + Vector2i(0,-2),
		coords + Vector2i(1,-2),
		coords + Vector2i(2,-2),
		coords + Vector2i(2,-1),
	]
	return array
	
func get_valid_spawnpoints(pos: Vector2) -> Array[Vector2]:
	var origin: Vector2 = local_to_map(pos)
	var spawnpoints: Array[Vector2i] = get_surrounding_cells_2(origin)
	spawnpoints = spawnpoints.filter(func(vec): return is_tile_free(vec))
	var spawnpoints_local: Array[Vector2] = []
	for sp in spawnpoints:
		spawnpoints_local.append(map_to_local(sp))
	return spawnpoints_local
	
func is_tile_free(tile: Vector2i) -> bool:
	if get_cell_atlas_coords(tile) == tile_free:
		return true
	else:
		return false
	
func set_tile_occupied(tile: Vector2) -> void:
	set_cell(tile, 0, tile_occupied, 0)
	
func set_tile_free(tile: Vector2, ) -> void:
	set_cell(tile, 0, tile_free, 0)
