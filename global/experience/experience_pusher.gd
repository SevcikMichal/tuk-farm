extends Node3D

@export
var save_id: String

@export
var level: Control

@onready
var _save_strategy: SaveStrategy = Mode.get_save_strategy()
var _experience_state: ExperienceState 

func _ready() -> void:
	var saved_experience_state = _save_strategy.load_experience_state(save_id)
	
	if not saved_experience_state:
		_experience_state = ExperienceState.new(0, 1, 1, 5, 5)
	else:
		_experience_state = saved_experience_state
		
	level.update_level(_experience_state.get_level(), false)
	level.update_progress(_experience_state.get_level_progress())

func _on_experience_gain_event() -> void:
	if _experience_state.update_experience_state():
		level.update_level(_experience_state.get_level())
	level.update_progress(_experience_state.get_level_progress())
	_save_strategy.save_experience_state(save_id, _experience_state)
