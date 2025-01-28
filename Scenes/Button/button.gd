extends Button

signal my_button_pressed(id: int)

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var id: int

func _on_button_down() -> void:
	my_button_pressed.emit(id)
	audio_stream_player.play()
