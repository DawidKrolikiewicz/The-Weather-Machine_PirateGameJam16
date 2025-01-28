extends CanvasLayer

@onready var menu_settings: Control = $Viewport/MenuSettings

var game_scene_path: String = "res://Scenes/World/world.tscn"

func _on_play_button_button_down() -> void:
	SceneTransition.change_scene(game_scene_path)
	
func _on_options_button_button_down() -> void:
	menu_settings.visible = !menu_settings.visible
