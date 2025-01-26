extends Node2D
class_name POI

signal attempt_to_spawn_new_poi(pos)
signal destory_me(me)

@onready var water_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/WaterBar
@onready var food_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/FoodBar
@onready var happy_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/HappyBar
@onready var health_bar: GaugeBar = $LabelsBot/CenterContainer/VBoxContainer/HealthBar

@onready var water_gauge: Gauge = $Gauges/WaterGauge
@onready var food_gauge: Gauge = $Gauges/FoodGauge
@onready var happy_gauge: Gauge = $Gauges/HappyGauge
@onready var health_gauge: Gauge = $Gauges/HealthGauge
@onready var productivity_gauge: Gauge = $Gauges/ProductivityGauge

var threshhold: float = 60
var base_money: float = 0.5

var ticks_to_spawn_new: int = 10
var spawn_new_count: int = 0

func _ready() -> void:
	SignalBus.tick.connect(_on_tick_timer_timeout)
	update_progress_bar(water_gauge, water_bar)
	update_progress_bar(food_gauge, food_bar)
	update_progress_bar(happy_gauge, happy_bar)
	update_progress_bar(health_gauge, health_bar)
	
func on_tick(data: WeatherData) -> void:
	water_gauge.value += data.water_per_tick
	food_gauge.value += data.food_per_tick
	happy_gauge.value += data.happy_per_tick
	
func _on_tick_timer_timeout():
	# COUNT HOW MANY SURVIVAL GAUGES ARE ABOVE THRESHHOLD
	var n: int = 0
	for g in [water_gauge, food_gauge, happy_gauge]:
		if g.value >= threshhold:
			n += 1
		
	# SET PRODUCTIVITY GAIN FOR NEXT TICK ACCORDINGLY 
	match(n):
		0:
			productivity_gauge.value_per_tick = -5
		1:
			productivity_gauge.value_per_tick = -2
		2:
			productivity_gauge.value_per_tick = 1
		3:
			productivity_gauge.value_per_tick = 3
	
	# ADD MONEY BASED ON PRODUCTIVITY LEVEL
	SignalBus.add_money.emit(base_money * productivity_gauge.value / 100)
	
	# IF PRODUCTIVITY ABOVE THE THRESHHOLD, PROGRESS TO SPAWNING NEW POI
	if productivity_gauge.value >= threshhold:
		spawn_new_count += 1
		if spawn_new_count >= ticks_to_spawn_new:
			spawn_new_count = 0
			attempt_to_spawn_new_poi.emit(position)
	
func update_progress_bar(gauge: Gauge, bar: GaugeBar) -> void:
	bar.value = gauge.value
	if gauge.value <= threshhold:
		bar.vis = true
	else:
		bar.vis = false

# SIGNALS

func _on_water_gauge_gauge_value_changed() -> void:
	update_progress_bar(water_gauge, water_bar)
	
func _on_food_gauge_gauge_value_changed() -> void:
	update_progress_bar(food_gauge, food_bar)

func _on_happy_gauge_gauge_value_changed() -> void:
	update_progress_bar(happy_gauge, happy_bar)

func _on_health_gauge_gauge_value_changed() -> void:
	update_progress_bar(health_gauge, health_bar)

func _on_water_gauge_gauge_value_zero() -> void:
	destory_poi()

func _on_food_gauge_gauge_value_zero() -> void:
	destory_poi()

func _on_happy_gauge_gauge_value_zero() -> void:
	destory_poi()

func _on_health_gauge_gauge_value_zero() -> void:
	destory_poi()

func destory_poi() -> void:
	destory_me.emit(self)
