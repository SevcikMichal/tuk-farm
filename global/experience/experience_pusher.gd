extends Node3D

@export
var level: Control

var _current_experience: int = 0
var _experience_rate: int = 1
var _level = 1

var _next_level = 5
var _level_increase = 5

func _on_experience_gain_event() -> void:
	_current_experience = _current_experience + _experience_rate
	if _current_experience >= _next_level:
		_current_experience = _current_experience % _next_level
		_next_level = _next_level + _level_increase
		_level = _level + 1
		level.update_level(_level)
	level.update_progress(float(_current_experience)/float(_next_level) * 100.0)
