extends Node3D

@export
var bucket: Node3D

@export
var level: Control

var _current_experience: int = 0
var _experience_rate: int = 10
var _level = 1

var _next_level = 50
var _level_increase = 10

func _on_milk_bucket_bucket_full() -> void:
	_current_experience = _current_experience + _experience_rate
	if _current_experience >= _next_level:
		_next_level += _next_level + _level_increase
		_level = _level + 1
		level.update_level(level)
		bucket.reset()
