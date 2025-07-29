extends Control

func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed(scene)


func _on_home_pressed():
	load_game_scene("res://simple_menu/simple_menu.tscn")
