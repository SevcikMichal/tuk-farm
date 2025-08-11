extends Node

const BUTTON_PRESSED_VIBRATION_DURATION_MS: int = 200

var _active_finger: int = -1
var _configuration: Configuration

func _ready() -> void:
	randomize()
	_configuration = Configuration.new()
	_configuration.load_self()

func begin_touch(finger_id: int) -> bool:
	if _active_finger == -1:
		_active_finger = finger_id
		return true
	return _active_finger == finger_id

func end_touch(finger_id: int) -> void:
	if _active_finger == finger_id:
		_active_finger = -1
		
func get_configuration() -> Configuration:
	return _configuration

func vibrate(duration_ms: int, amplitude: float = -1.0) -> void:
	if _configuration.is_haptics_enabled():
		Input.vibrate_handheld(duration_ms, amplitude)
