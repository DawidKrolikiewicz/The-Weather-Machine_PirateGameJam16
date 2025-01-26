extends Node
class_name Gauge

signal gauge_value_changed
signal gauge_value_zero

const MAX_VALUE: int = 100
const MIN_VALUE: int = 0

@export_range(-10, 10, 1, "suffix:/tick") var value_per_tick: int = -1
@export_range(0, 100, 1) var value: int = 100:
	set(v):
		v = clampi(v, MIN_VALUE, MAX_VALUE)
		if value != v:
			value = v
			gauge_value_changed.emit()
			if value == 0:
				gauge_value_zero.emit()

func _ready() -> void:
	SignalBus.tick.connect(_on_tick_timer_timeout)

func _on_tick_timer_timeout() -> void:
	value += value_per_tick
