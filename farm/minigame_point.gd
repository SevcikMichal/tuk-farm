extends Node3D

@export
var scene: PackedScene

@export
var interaction_radius: float = 3

func _check_proximity_and_act(farmer_position: Vector3) -> void:
	var distance = global_position.distance_to(farmer_position)
	if distance < interaction_radius:
		load_game_scene()

func load_game_scene() -> void:
	get_tree().change_scene_to_packed.call_deferred(scene)

func _on_farmer_walk_finished(farmer_position: Vector3) -> void:
	_check_proximity_and_act(farmer_position)
