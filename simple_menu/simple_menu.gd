extends Control


func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)


func _on_offline_pressed() -> void:
	Mode.set_mode(Mode.NetworkMode.OFFLINE)
	load_game_scene("res://farm/farm.tscn")
