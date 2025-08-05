extends Node3D


@export
var scene: PackedScene

@export
var interaction_radius: float = 3

func _check_proximity_and_act(farmer_position: Vector3) -> void:
	var flat_self = Vector2(global_position.x, global_position.z)
	var flat_farmer = Vector2(farmer_position.x, farmer_position.z)
	var distance = flat_self.distance_to(flat_farmer)
	if distance < interaction_radius:
		load_game_scene()

func load_game_scene() -> void:
	get_tree().change_scene_to_packed.call_deferred(scene)

func _on_farmer_walk_finished(farmer_position: Vector3) -> void:
	_check_proximity_and_act(farmer_position)
