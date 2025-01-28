extends Node2D
class_name POISpawner

@export var poi_grid: POIGrid

@export var initial_spawn_count: int = 1

var poi_scene: PackedScene = preload("res://Scenes/POI/poi.tscn")

func _ready() -> void:
	## WARNING: THIS CAN SPAWN MORE THAN ONE ON TOP OF EACHOTHER - REWORK PROBABLY
	for i in range(initial_spawn_count):
		spawn_poi(Vector2(randi_range(-300,300), randi_range(-300,300)))
		
func _process(_delta: float) -> void:
	if get_child_count() <= 1:
			SignalBus.game_over.emit()

func spawn_poi(pos: Vector2) -> void:
	# MAP TO GRID COORDINATES
	var tile: Vector2i = poi_grid.local_to_map(pos)
	
	# MARK TILE AS OCCUPIED
	poi_grid.set_tile_occupied(tile)
	
	# INSTANCIATE NEW POI AND INITIALIZE IT 
	var poi_new: POI = poi_scene.instantiate()
	add_child(poi_new)
	poi_new.attempt_to_spawn_new_poi.connect(_on_attempt_to_spawn_new_poi)
	poi_new.destory_me.connect(_on_destory_me)
	poi_new.position = poi_grid.map_to_local(tile)
	
func _on_destory_me(poi: POI) -> void:
	# MAP TO GRID COORDINATES
	var tile: Vector2i = poi_grid.local_to_map(poi.position)
	
	# MARK TILE AS FREE
	poi_grid.set_tile_free(tile)
	
	# QUEUE FREE THE POI
	poi.queue_free()
	
	
func _on_attempt_to_spawn_new_poi(pos: Vector2):
	# GET VALID SPAWNPOINTS FROM GRID
	var spawnpoints: Array[Vector2] = poi_grid.get_valid_spawnpoints(pos)
	
	# IF NO VALID SPAWNPOINTS, RETURN
	if spawnpoints.is_empty():
		return
		
	# PICK SPAWNPOINT FROM THE ARRAY
	var picked: Vector2 = spawnpoints[randi_range(0, spawnpoints.size()-1)]
	
	# SPAWN_POI() AT THIS LOCATION
	spawn_poi(picked)
	
