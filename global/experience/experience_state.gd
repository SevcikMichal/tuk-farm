class_name ExperienceState

var _current_experience: int
var _experience_rate: int
var _level: int

var _next_level: int
var _level_increase: int

func _init(current_experience: int, experience_rate: int, level: int, next_level: int, level_increase: int) -> void:
	_current_experience = current_experience
	_experience_rate = experience_rate
	_level = level
	_next_level = next_level
	_level_increase = level_increase

func update_experience_state() -> bool:
	_current_experience += _current_experience + _experience_rate
	if _current_experience >= _next_level:
		_update_level()
		return true
	return false

func _update_level() -> void:
	_current_experience = _current_experience % _next_level
	_next_level = _next_level + _level_increase
	_level = _level + 1

func get_level() -> int:
	return _level

func get_level_progress() -> float:
	return float(_current_experience)/float(_next_level) * 100.0
