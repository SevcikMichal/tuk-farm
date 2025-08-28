extends Node3D

signal tree_hit
signal swing_finished

@onready
var _animations: AnimationPlayer = get_node("AnimationPlayer")

@onready
var _swoosh: AudioStreamPlayer3D = get_node("Swoosh")

@onready
var _tick: AudioStreamPlayer3D = get_node("Tick")

func swing():
	_swoosh.pitch_scale = randf_range(1.8, 2.0)
	_swoosh.play()
	_animations.play("swing", -1, 1.5)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "swing":
		emit_signal("swing_finished")
		
func hit() -> void:
	_tick.pitch_scale = randf_range(0.4, 0.6)
	_tick.play()
	emit_signal("tree_hit")
