extends CanvasLayer

@onready var pause_menu: Control = $Viewport/PauseMenu

var game_scene_path: String = "res://Scenes/World/world.tscn"

func _on_play_button_button_down() -> void:
	SceneTransition.change_scene(game_scene_path)
	
func _on_options_button_button_down() -> void:
	pause_menu.visible = !pause_menu.visible
