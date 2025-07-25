extends Control

const MAX_PAIR_DELTA: int = 150
const GREAT_RYTHM_RANGE: int = 300
const GOOD_RHYTHM_RANGE: int = 800

signal rhythm(state: String, last_zone: String)
signal reset()

@onready
var _animation: AnimationPlayer = get_node("AnimationPlayer")

@onready
var _idle_timer: Timer = get_node("IdleTimer")

@onready
var _reset_timer: Timer = get_node("ResetTimer")

var _left_swipe_time: int = 0
var _left_dir: String = ""

var _right_swipe_time: int = 0
var _right_dir: String = ""

var _last_success_time: int = 0
var _input_locked: bool = false

var _last_left_dir: String = ""
var _last_right_dir: String = ""

var _left_released: bool = false
var _right_released: bool = false

func _ready() -> void:
	_animation.play("hint")

func _on_zone_drag(zone: String, direction: String) -> void:
	if _input_locked:
		return
		
	if zone == "left":
		_on_left_drag(direction)
	else:
		_on_right_drag(direction)

func _on_left_drag(direction: String) -> void:
	_animation.stop()
	_idle_timer.start()
	_left_released = false
	_reset_timer.stop()
	_left_swipe_time = Time.get_ticks_msec()
	_left_dir = direction
	_try_register_gesture()

func _on_right_drag(direction: String) -> void:
	_animation.stop()
	_idle_timer.start()
	_right_released = false
	_reset_timer.stop()
	_right_swipe_time = Time.get_ticks_msec()
	_right_dir = direction
	_try_register_gesture()

func _try_register_gesture() -> void:
	if _left_dir == "" or _right_dir == "":
		return
	_input_locked = true
	
	var last_zone = "left" if _left_dir == "down" else "right"
	
	var delta = abs(_left_swipe_time - _right_swipe_time)
	var are_opposite = _left_dir != _right_dir
	
	if not are_opposite:
		emit_signal("rhythm", "bad", last_zone)
		_reset_swipe(true)
		return
	elif delta > MAX_PAIR_DELTA:
		emit_signal("rhythm", "bad", last_zone)
		_reset_swipe(true)
		return
	else:
		if not _is_valid_followup():
			emit_signal("rhythm", "bad", last_zone)
			_reset_swipe(true)
			return
		
		_last_left_dir = _left_dir
		_last_right_dir = _right_dir
		
		var now = Time.get_ticks_msec()
		
		if _last_success_time > 0:
			var rhythm_delta = now - _last_success_time
			if rhythm_delta <= GREAT_RYTHM_RANGE:
				emit_signal("rhythm", "great", last_zone)
			elif rhythm_delta <= GOOD_RHYTHM_RANGE:
				emit_signal("rhythm", "good", last_zone)
			else:
				emit_signal("rhythm", "bad", last_zone)
		else:
			emit_signal("rhythm", "good", last_zone)

		_last_success_time = now

	# Reset swipe data
	_reset_swipe()


func _reset_swipe(reset_success_time: bool = false):
	_left_dir = ""
	_right_dir = ""
	_left_swipe_time = 0
	_right_swipe_time = 0
	_input_locked = false
	_last_left_dir = ""
	_last_right_dir = ""
	_left_released = false
	_right_released = false
	if reset_success_time:
		_last_success_time = 0


func _is_valid_followup() -> bool:
	if _last_left_dir == "" or _last_right_dir == "":
		return true  # First gesture — no history to compare to

	return (
		_last_left_dir == "up" and _last_right_dir == "down" and
		_left_dir == "down" and _right_dir == "up"
	) or (
		_last_left_dir == "down" and _last_right_dir == "up" and
		_left_dir == "up" and _right_dir == "down"
	)

func _on_idle_timer_timeout() -> void:
	if not _input_locked:
		_animation.play("hint")
		_reset_swipe()

func _on_zone_released(zone: String) -> void:
	if zone == "left":
		_left_released = true
	if zone == "right":
		_right_released = true
	if _left_released and _right_released:
		_reset_timer.start()

func _on_reset_timer_timeout() -> void:
	emit_signal("reset")
	_reset_swipe(true)
