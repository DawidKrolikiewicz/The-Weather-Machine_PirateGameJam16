extends Button

signal my_button_pressed(id: int)

@export var id: int

func _on_button_down() -> void:
	my_button_pressed.emit(id)
