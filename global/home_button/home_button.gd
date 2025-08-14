extends Control

@onready
var _click_sound: AudioStreamPlayer = get_node("ClickSound")

func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)

func _on_home_pressed():
	Globals.vibrate(Globals.BUTTON_PRESSED_VIBRATION_DURATION_MS)
	_click_sound.play_click()
	load_game_scene("res://farm/farm.tscn")
