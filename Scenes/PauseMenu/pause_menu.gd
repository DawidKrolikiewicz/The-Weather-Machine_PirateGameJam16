extends Control

@onready var music_vol_slider: HSlider = $VBoxContainer/CenterContainer3/VBoxContainer/MarginContainer/MusicVolSlider

@onready var sfx_vol_slider: HSlider = $VBoxContainer/CenterContainer5/VBoxContainer/MarginContainer/SFXVolSlider

@onready var label: Label = $VBoxContainer/CenterContainer4/VBoxContainer/Label
@onready var game_speed_slider: HSlider = $VBoxContainer/CenterContainer4/VBoxContainer/MarginContainer/GameSpeedSlider

var main_menu_scene_path: String = "res://Scenes/MainMenu/main_menu.tscn"

func _ready() -> void:
	music_vol_slider.value = Settings.music_volume
	
	sfx_vol_slider.value = Settings.sfx_volume
	
	label.text = "Game Speed: %3d%%" % Settings.game_speed
	game_speed_slider.value = Settings.game_speed

func _on_to_menu_button_button_down() -> void:
	Engine.time_scale = 1
	SceneTransition.change_scene(main_menu_scene_path)
	
func _on_music_vol_slider_value_changed(value: float) -> void:
	Settings.music_volume = value
	
func _on_sfx_vol_slider_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	
func _on_game_speed_slider_value_changed(value: float) -> void:
	Settings.game_speed = int(value)
	label.text = "Game Speed: %3d%%" % value
	
