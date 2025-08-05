extends Node3D

@export
var level: Control

@onready
var _experience_state: ExperienceState = ExperienceState.new(0, 1, 1, 5, 5)

func _on_experience_gain_event() -> void:
	_experience_state.update_experience_state()
	level.update_level(_experience_state.get_level())
	level.update_progress(_experience_state.get_level_progress())
