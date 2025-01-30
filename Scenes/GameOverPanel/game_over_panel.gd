extends PanelContainer

var value: float = 0
var main_menu_scene_path: String = "res://Scenes/MainMenu/main_menu.tscn"

@onready var label_2: Label = $VBoxContainer/Label2

func _ready() -> void:
	SignalBus.game_over_score.connect(_on_game_over_score)
	
func _on_game_over_score(score: float) -> void:
	label_2.text = "Total money earned: %.2f$" % score
	
func _on_button_button_down() -> void:
	Engine.time_scale = 1.0
	SceneTransition.change_scene(main_menu_scene_path)
