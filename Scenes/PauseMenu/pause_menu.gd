extends Control

var main_menu_scene_path: String = "res://Scenes/MainMenu/main_menu.tscn"

func _on_to_menu_button_button_down() -> void:
	Engine.time_scale = 1
	SceneTransition.change_scene(main_menu_scene_path)
