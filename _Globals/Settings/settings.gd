extends Node

var music_volume: int = 50
var sfx_volume: int = 50
var game_speed: float = 100.0:
	set(value):
		game_speed = value
		SignalBus.game_speed_changed.emit()
