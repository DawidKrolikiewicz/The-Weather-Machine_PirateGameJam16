extends Node2D
class_name World

@onready var ui: UI = $UI
@onready var tick_timer: Timer = $TickTimer

@export var button_spawns: Array[WeatherData]
@export var prices: Array[float]

@onready var weather_spawner: WeatherSpawner = $WeatherSpawner

@onready var button_bought: AudioStreamPlayer = $ButtonBought
@onready var button_not_enough_money: AudioStreamPlayer = $ButtonNotEnoughMoney

var total_money: float = 0
var money: float = 0:
	set(value):
		money = value
		if value > total_money:
			total_money = value
		ui.update_label(value)

func _ready() -> void:
	SignalBus.add_money.connect(_on_add_money)
	SignalBus.game_speed_changed.connect(_on_game_speed_changed)
	SignalBus.game_over.connect(_on_game_over)
	_on_game_speed_changed()
	
func _on_tick_timer_timeout() -> void:
	SignalBus.tick.emit()
	print(total_money)
	
func _on_add_money(value: float) -> void:
	money += value
	
func _on_game_speed_changed() -> void:
	tick_timer.wait_time = 100 / Settings.game_speed
	
func _on_ui_button_pressed(id: int) -> void:
	if attempt_to_buy(prices[id]):
		weather_spawner.player_spawn_weather_zone(button_spawns[id])
		button_bought.play()
	else:
		button_not_enough_money.play()

func _on_game_over() -> void:
	SignalBus.game_over_score.emit(total_money)
	
func attempt_to_buy(price: float) -> bool:
	if money >= price:
		money -= price
		return true
	else:
		return false
		
	
