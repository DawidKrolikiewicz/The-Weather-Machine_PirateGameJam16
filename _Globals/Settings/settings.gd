extends Node

var music_volume: float = 0.8:
	set(value):
		music_volume = value
		var bus_index: int = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
var sfx_volume: float = 0.8:
	set(value):
		sfx_volume = value
		var bus_index: int = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

var game_speed: float = 100.0:
	set(value):
		game_speed = value
		SignalBus.game_speed_changed.emit()
