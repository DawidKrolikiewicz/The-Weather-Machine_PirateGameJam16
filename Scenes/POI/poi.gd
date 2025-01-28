extends Node2D
class_name POI

signal attempt_to_spawn_new_poi(pos)
signal destory_me(me)

@export var poi_types: Array[POIType]

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var water_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/WaterBar
@onready var food_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/FoodBar
@onready var happy_bar: GaugeBar = $LabelsTop/CenterContainer/VBoxContainer/HappyBar
@onready var health_bar: GaugeBar = $LabelsBot/CenterContainer/VBoxContainer/HealthBar

@onready var water_icon: Control = $Bubble/HBoxContainer/WaterIcon
@onready var food_icon: Control = $Bubble/HBoxContainer/FoodIcon
@onready var happy_icon: Control = $Bubble/HBoxContainer/HappyIcon

@onready var water_gauge: Gauge = $Gauges/WaterGauge
@onready var food_gauge: Gauge = $Gauges/FoodGauge
@onready var happy_gauge: Gauge = $Gauges/HappyGauge
@onready var health_gauge: Gauge = $Gauges/HealthGauge
@onready var productivity_gauge: Gauge = $Gauges/ProductivityGauge

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var show_icons: bool = false

var threshhold: float = 60
var base_money: float = 0.5

var ticks_to_spawn_new: int = 60
var spawn_new_count: int = 0

func _ready() -> void:
	var poi_type: POIType = poi_types[randi_range(0, poi_types.size() - 1)]
	
	water_gauge.value_per_tick = poi_type.water_per_tick
	food_gauge.value_per_tick = poi_type.food_per_tick
	happy_gauge.value_per_tick = poi_type.happy_per_tick
	
	sprite_2d.texture = poi_type.texture
	
	SignalBus.tick.connect(_on_tick_timer_timeout)
	update_progress_bar(water_gauge, water_bar)
	update_progress_bar(food_gauge, food_bar)
	update_progress_bar(happy_gauge, happy_bar)
	update_progress_bar(health_gauge, health_bar)
	
	audio_stream_player.play()
	
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
	
	# BUBBLE ANIMATIONS
	if animation_player.is_playing() and n == 3:
		animation_player.play("BubbleOutro")
	elif !animation_player.is_playing() and n != 3:
		animation_player.play("BubbleIntro")
	
	# IF PRODUCTIVITY ABOVE THE THRESHHOLD, PROGRESS TO SPAWNING NEW POI
	if productivity_gauge.value >= threshhold:
		spawn_new_count += 1
		if spawn_new_count >= ticks_to_spawn_new:
			spawn_new_count = 0
			attempt_to_spawn_new_poi.emit(position)
		
	
func update_progress_bar(gauge: Gauge, bar: GaugeBar, icon: Control = null) -> void:
	bar.value = gauge.value
	if gauge.value <= threshhold:
		bar.vis = true
		if icon and show_icons:
			map_value_to_sprite_frame(gauge.value, icon.get_child(0))
			icon.visible = true
	else:
		bar.vis = false
		if icon:
			icon.visible = false

# SIGNALS

func _on_water_gauge_gauge_value_changed() -> void:
	update_progress_bar(water_gauge, water_bar, water_icon)
	
func _on_food_gauge_gauge_value_changed() -> void:
	update_progress_bar(food_gauge, food_bar, food_icon)

func _on_happy_gauge_gauge_value_changed() -> void:
	update_progress_bar(happy_gauge, happy_bar, happy_icon)

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
	
func play_bubble_loop() -> void:
	animation_player.play("BubbleLoop")
	
func map_value_to_sprite_frame(value: int, sprite: Sprite2D) -> void:
	# 60 - 51
	if value > 50:
		sprite.frame = 0
		
	# 50 - 41
	elif value > 40:
		sprite.frame = 1
		
	# 40 - 31
	elif value > 30:
		sprite.frame = 2
		
	# 30 - 21
	elif value > 20:
		sprite.frame = 3
		
	# 20 - 0
	else:
		sprite.frame = 4
