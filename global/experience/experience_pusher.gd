extends Node3D

@export
var level: Control


var _experience_state: ExperienceState 

func _ready() -> void:
	Globals.set

func _on_experience_gain_event() -> void:
	if _experience_state.update_experience_state():
		level.update_level(_experience_state.get_level())
	level.update_progress(_experience_state.get_level_progress())
