extends Node3D

signal eggs_collected

const EGGS_TO_LAY: int = 2

@export
var egg_object: PackedScene

@onready
var squeeze_player: AnimationPlayer = get_node("Squeeze")

@onready
var egg_spawner: Node3D = get_node("EggSpawner")

@onready
var _idle_sound: AudioStreamPlayer3D = get_node("IdleSound")

@onready
var _squeek_sound: AudioStreamPlayer3D = get_node("SqueekSound")

var _egg_counter = 0

func _on_pitch_performed():	
	Globals.vibrate(100)
	squeeze_player.queue("Squeeze")

func _on_squeeze_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Squeeze":
		var egg_instance = egg_object.instantiate()
		add_child(egg_instance)
		egg_instance.global_transform.origin = egg_spawner.position
		_egg_counter = _egg_counter + 1
		if _egg_counter == EGGS_TO_LAY:
			_egg_counter = 0
			emit_signal("eggs_collected")

func _on_timer_timeout():
	var roll = randf()
	if roll < 0.3:
		play_sound(0)

func play_sound(sound: int) -> void:
	if sound == 0:
		var pitch = randf_range(1.0, 1.3)
		_idle_sound.pitch_scale = pitch
		_idle_sound.play()
	if sound == 1:
		var pitch = randf_range(1.0, 1.5)
		_squeek_sound.pitch_scale = pitch
		_squeek_sound.play()
