extends Control


func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)


func _on_cow_pressed() -> void:
	load_game_scene("res://cow_milking/cow_milking.tscn")


func _on_chicken_pressed() -> void:
	load_game_scene("res://chicken_eggs/chicken_eggs.tscn")


func _on_fishing_pressed() -> void:
	load_game_scene("res://fishing/fishing.tscn")


func _on_sheep_pressed() -> void:
	load_game_scene("res://sheep_shearing/sheep_shearing.tscn")


func _on_farm_pressed():
	load_game_scene("res://farm/farm.tscn")
