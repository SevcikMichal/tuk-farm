extends Node

var _active_finger: int = -1

func _ready() -> void:
	randomize()

func begin_touch(finger_id: int) -> bool:
	if _active_finger == -1:
		_active_finger = finger_id
		return true
	return _active_finger == finger_id

func end_touch(finger_id: int) -> void:
	if _active_finger == finger_id:
		_active_finger = -1
