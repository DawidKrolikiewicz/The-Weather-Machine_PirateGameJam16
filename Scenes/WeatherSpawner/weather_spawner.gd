extends Node2D
class_name WeatherSpawner

@export var positive_weathers: Array[WeatherData] = [] 
@export var neutral_weathers: Array[WeatherData] = [] 

@export var positive_chance: float = 80.0 
@export var neutral_chance: float = 20.0  

@export var positive_chance_modifier: float = -1.0  
@export var neutral_chance_modifier: float = 1.0  

@export var min_positive_chance: float = 30.0 
@export var max_neutral_chance: float = 70.0  

@export var min_weight: float = 0.0  
@export var max_weight: float = 100.0 

@onready var timer: Timer = $Timer

var weathers_array : Array[WeatherZone] = []
var weather_zone: PackedScene = preload("res://Scenes/WeatherZone/weather_zone.tscn")

func _ready() -> void:
	randomize_timer_wait_time()
	timer.start()

	spawn_weather_zone()
	spawn_weather_zone()
	spawn_weather_zone()


func _on_timer_timeout() -> void:
	randomize_timer_wait_time()
	update_weather_weights()
	spawn_weather_zone()
	#print(weathers_array)

func randomize_timer_wait_time() -> void:
	#timer.wait_time = randi_range(10, 30)
	timer.wait_time = 1

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
	else:
		return select_weather_from_group(neutral_weathers)
		
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

	print("Positive chance:", positive_chance, "Neutral chance:", neutral_chance)
