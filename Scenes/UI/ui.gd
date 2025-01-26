extends CanvasLayer
class_name UI

signal button_pressed(id: int)

@onready var h_box_container: HBoxContainer = $BottomPanel/HBoxContainer/PanelButtons/HBoxContainer
@onready var label: Label = $BottomPanel/HBoxContainer/PanelMoneyDisplay/Label
@onready var pause_menu: Control = $PauseMenu
@onready var info_label: Label = $BottomPanel/HBoxContainer/PanelHoverDisplay/InfoLabel


func _ready() -> void:
	for button in h_box_container.get_children():
		button.my_button_pressed.connect(_on_my_button_pressed)
		
	SignalBus.display_weather_info.connect(_on_display_weather_info)
	
func _process(delta: float) -> void:
	info_label.text = ""
	
func _on_my_button_pressed(id: int) -> void:
	button_pressed.emit(id)
	
func _on_display_weather_info(data: WeatherData) -> void:
	info_label.text = "Water: %d\nFood: %d\nHappy: %d" % [data.water_per_tick, data.food_per_tick, data.happy_per_tick]
	
func update_label(value: float) -> void:
	label.text = "%.2f$" % value

func _on_pause_button_button_down() -> void:
	if Engine.time_scale != 0:
		Engine.time_scale = 0
		pause_menu.visible = true
	else:
		Engine.time_scale = 1
		pause_menu.visible = false
