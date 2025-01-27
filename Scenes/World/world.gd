extends Node2D
class_name World

@onready var ui: UI = $UI
@onready var tick_timer: Timer = $TickTimer

var money: float = 0:
	set(value):
		money = value
		ui.update_label(value)

func _ready() -> void:
	SignalBus.add_money.connect(_on_add_money)
	SignalBus.game_speed_changed.connect(_on_game_speed_changed)
	_on_game_speed_changed()
	
func _on_tick_timer_timeout() -> void:
	SignalBus.tick.emit()
	
func _on_add_money(value: float) -> void:
	money += value
	
func _on_game_speed_changed() -> void:
	tick_timer.wait_time = 100 / Settings.game_speed
	
func _on_ui_button_pressed(id: int) -> void:
	match id:
		1:
			money = 0
			print("Money set to 0")
		_:
			printerr("NOT IMPLEMENTED: Button %d" % id)
