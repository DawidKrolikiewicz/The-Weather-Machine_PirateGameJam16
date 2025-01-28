extends Node2D
class_name WeatherSpawner

@export var weathers_to_spawn: Array[WeatherData] = []

@onready var timer: Timer = $Timer

var weathers_array: Array[WeatherZone] = []
var weather_zone: PackedScene = preload("res://Scenes/WeatherZone/weather_zone.tscn")

func _ready() -> void:
	randomize_timer_wait_time()
	timer.start()
	spawn_weather_zone()
	spawn_weather_zone()
	spawn_weather_zone()

func _on_timer_timeout() -> void:
	randomize_timer_wait_time()
	spawn_weather_zone()
	#print(weathers_array)

func randomize_timer_wait_time() -> void:
	#timer.wait_time = randi_range(10, 30)
	timer.wait_time = 5

func spawn_weather_zone() -> void:
	var instance: WeatherZone = weather_zone.instantiate()
	instance.position = Vector2(randi_range(-300, 300), randi_range(-300, 300))
	instance.data = weathers_to_spawn[randi_range(0, weathers_to_spawn.size()-1)]
	add_child(instance)
	weathers_array.append(instance)
	instance.disolve_finished.connect(_on_weather_disolved)
	
func _on_weather_disolved(zone: WeatherZone) -> void:
	weathers_array.erase(zone)
	zone.queue_free()
