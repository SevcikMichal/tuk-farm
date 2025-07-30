extends Node

var active_finger: int = -1

func begin_touch(finger_id: int) -> bool:
	if active_finger == -1:
		active_finger = finger_id
		return true
	return active_finger == finger_id

func end_touch(finger_id: int) -> void:
	if active_finger == finger_id:
		active_finger = -1

func _ready() -> void:
	randomize()
