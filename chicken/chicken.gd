extends Node3D

@export
var egg_object: PackedScene

@onready
var squeeze_player: AnimationPlayer = get_node("Squeeze")

@onready
var egg_spawner: Node3D = get_node("EggSpawner")

func _on_pitch_performed():	
	squeeze_player.queue("Squeeze")

func _on_squeeze_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Squeeze":
		var egg_instance = egg_object.instantiate()
		add_child(egg_instance)
		egg_instance.global_transform.origin = egg_spawner.position
