extends CanvasLayer
class_name UI

signal button_pressed(id: int)

@onready var h_box_container: HBoxContainer = $BottomPanel/HBoxContainer/PanelButtons/HBoxContainer
@onready var label: Label = $BottomPanel/HBoxContainer/PanelMoney/PanelMoneyDisplay/Label
@onready var label_total: Label = $BottomPanel/HBoxContainer/PanelMoney/PanelMoneyDisplay2/Label

@onready var pause_menu: Control = $PauseMenu
@onready var game_over_panel: PanelContainer = $GameOverPanel

@onready var info_h_box_container: HBoxContainer = $BottomPanel/HBoxContainer/PanelHoverDisplay/HBoxContainer
@onready var info_label_water: Label = $BottomPanel/HBoxContainer/PanelHoverDisplay/HBoxContainer/PanelContainer1/Control1/InfoLabel
@onready var info_label_food: Label = $BottomPanel/HBoxContainer/PanelHoverDisplay/HBoxContainer/PanelContainer2/Control2/InfoLabel
@onready var info_label_happy: Label = $BottomPanel/HBoxContainer/PanelHoverDisplay/HBoxContainer/PanelContainer3/Control3/InfoLabel


func _ready() -> void:
	for button in h_box_container.get_children():
		button.my_button_pressed.connect(_on_my_button_pressed)
		
	SignalBus.display_weather_info.connect(_on_display_weather_info)
	SignalBus.game_over.connect(_on_game_over)
	
func _process(_delta: float) -> void:
	info_h_box_container.visible = false
	if Input.is_action_just_pressed("Pause"):
		_on_pause_button_button_down()
	
func _on_my_button_pressed(id: int) -> void:
	button_pressed.emit(id)
	
func _on_display_weather_info(data: WeatherData) -> void:
	info_h_box_container.visible = true
	info_label_water.text = "%d" % data.water_per_tick
	info_label_food.text = "%d" % data.food_per_tick
	info_label_happy.text = "%d" % data.happy_per_tick
	
func update_label(money: float, total_money: float) -> void:
	label.text = "MONEY: %.2f$" % money
	label_total.text = "TOTAL: %.2f$" % total_money

func _on_pause_button_button_down() -> void:
	if Engine.time_scale != 0:
		Engine.time_scale = 0
		pause_menu.visible = true
	else:
		Engine.time_scale = 1
		pause_menu.visible = false
		
func _on_game_over() -> void:
	game_over_panel.visible = true
