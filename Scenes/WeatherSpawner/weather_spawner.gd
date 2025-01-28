extends Node2D
class_name WeatherSpawner

@export var positive_weathers: Array[WeatherData] = [] 
@export var neutral_weathers: Array[WeatherData] = [] 
@export var negative_weathers: Array[WeatherData] = []

@export var positive_chance: float = 80.0 
@export var neutral_chance: float = 20.0  
@export var negative_chance: float = 0.0  

@export var positive_chance_modifier: float = -1.0  
@export var neutral_chance_modifier: float = 1.0  
@export var negative_chance_modifier: float = 0.0  

@export var min_positive_chance: float = 30.0 
@export var max_neutral_chance: float = 70.0  
@export var max_negative_chance: float = 0.0 

@export var min_weight: float = 0.0  
@export var max_weight: float = 100.0 

var weathers_array : Array[WeatherZone] = []
var max_weather_count: int = 8

var tick_counter: int = 0

var weather_zone: PackedScene = preload("res://Scenes/WeatherZone/weather_zone.tscn")

func _ready() -> void:
	SignalBus.tick.connect(_on_tick_timer_timeout)

func _on_tick_timer_timeout() -> void:
	tick_counter += 1
	if tick_counter >= 30: # Every 30 ticks increase max weather count
		tick_counter = 0
		max_weather_count += 2
		
	update_weather_weights()
	if weathers_array.size() < max_weather_count:
		spawn_weather_zone()

func spawn_weather_zone() -> void:
	var instance: WeatherZone = weather_zone.instantiate()
	instance.position = Vector2(randi_range(-300, 300), randi_range(-300, 300))
	instance.data = get_random_weather_data()
	add_child(instance)
	weathers_array.append(instance)
	instance.disolve_finished.connect(_on_weather_disolved)
	
func _on_weather_disolved(zone: WeatherZone) -> void:
	weathers_array.erase(zone) 
	zone.queue_free()
	
func get_random_weather_data() -> WeatherData:
	var total_chance = positive_chance + neutral_chance
	var random_value = randf() * total_chance

	if random_value < positive_chance:
		return select_weather_from_group(positive_weathers)
	elif random_value < positive_chance + neutral_chance:
		return select_weather_from_group(neutral_weathers)
	else:
		return select_weather_from_group(negative_weathers)
		
func select_weather_from_group(weathers: Array[WeatherData]) -> WeatherData:
	var index = randi() % weathers.size()
	return weathers[index]

func calculate_sum(array: Array[float]) -> int:
	var total = 0
	for value in array:
		total += value
	return total
	
func update_weather_weights() -> void:
	positive_chance = clamp(
		positive_chance + positive_chance_modifier,
		min_positive_chance,
		100
	)

	neutral_chance = clamp(
		neutral_chance + neutral_chance_modifier,
		0,
		max_neutral_chance
	)
	
	negative_chance = clamp(
		negative_chance + negative_chance_modifier,
		0,
		max_negative_chance
	)

	print("Positive chance:", positive_chance, " | Neutral chance:", neutral_chance, " | Negative chance:", negative_chance)
