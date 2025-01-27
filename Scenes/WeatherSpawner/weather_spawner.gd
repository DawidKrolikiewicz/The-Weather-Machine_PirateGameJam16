extends Node2D
class_name WeatherSpawner

@export var weathers_to_spawn: Array[WeatherData] = []
@export var base_weather_weights: Array[float] = []
@export var weight_modifiers: Array[float] = [] 
@export var min_weight: float = 0.0 
@export var max_weight: float = 100.0 
@export var max_rainy_weight: float = 70.0
@export var min_sunny_weight: float = 30.0

@onready var timer: Timer = $Timer

var weathers_array: Array[WeatherZone] = []
var weather_zone: PackedScene = preload("res://Scenes/WeatherZone/weather_zone.tscn")
var weather_weights: Array[float] = []

func _ready() -> void:
	if weathers_to_spawn.size() != base_weather_weights.size():
		push_error("weathers_to_spawn and base_weather_weights must have the same size!")
		return
	for weight in base_weather_weights:
		weather_weights.append(float(weight))
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
	var total_weight = calculate_sum(weather_weights)
	var random_value = randi() % total_weight
	var cumulative_weight = 0.0
	for i in range(weathers_to_spawn.size()):
		cumulative_weight += weather_weights[i]
		if random_value < cumulative_weight:
			return weathers_to_spawn[i]
	return weathers_to_spawn[0]

func calculate_sum(array: Array[float]) -> int:
	var total = 0
	for value in array:
		total += value
	return total
	
func update_weather_weights() -> void:
	for i in range(weather_weights.size()):
		
		if weathers_to_spawn[i].name == "Rain" and weather_weights[i] < max_rainy_weight:
			weather_weights[i] += weight_modifiers[i]
			if weather_weights[i] > max_rainy_weight:
				weather_weights[i] = max_rainy_weight
				
		elif weathers_to_spawn[i].name == "Sun Rays" and weather_weights[i] > min_sunny_weight:
			weather_weights[i] += weight_modifiers[i] 
			if weather_weights[i] < min_sunny_weight:
				weather_weights[i] = min_sunny_weight
				
		if weather_weights[i] < min_weight:
			weather_weights[i] = min_weight
		elif weather_weights[i] > max_weight:
			weather_weights[i] = max_weight
	print("Updated weights:", weather_weights)
