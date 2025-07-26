extends Control

signal swipe_up_detected
signal swipe_down_detected

const MIN_SWIPE_DISTANCE := 150
const MAX_SWIPE_TIME_MS := 500

@onready 
var _hint_arrow: TextureRect = get_node("MarginContainer/Up")

@onready
var _hint_animation: AnimationPlayer = get_node("Hint")

@onready 
var _hint_timer: Timer = get_node("HintTimer")

var _start_position: Vector2
var _start_time: int
var _swipe_valid := false

var _allow_swipe_up := true
var _allow_swipe_down := false

func _ready():
	_hint_animation.play("hint")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_start_position = event.position
		_start_time = Time.get_ticks_msec()
		_swipe_valid = false

	elif event is InputEventScreenDrag:
		var delta_y = event.position.y - _start_position.y
		var duration = Time.get_ticks_msec() - _start_time

		if _allow_swipe_up and -delta_y > MIN_SWIPE_DISTANCE and duration < MAX_SWIPE_TIME_MS:
			_swipe_valid = true
		elif _allow_swipe_down and delta_y > MIN_SWIPE_DISTANCE and duration < MAX_SWIPE_TIME_MS:
			_swipe_valid = true

	elif event is InputEventScreenTouch and not event.pressed:
		if _swipe_valid:
			_hint_animation.stop()
			_hint_timer.start()
			if _allow_swipe_up:
				_allow_swipe_up = false
				emit_signal("swipe_up_detected") # wait for throw to finish before allowing down
			elif _allow_swipe_down:
				_allow_swipe_down = false
				emit_signal("swipe_down_detected")
		_swipe_valid = false

func _on_fishing_rod_hook_finished():
	_allow_swipe_up = true
	_allow_swipe_down = false
	_hint_arrow.flip_v = true

func _on_fishing_rod_throw_finished():
	_allow_swipe_down = true
	_allow_swipe_up = false
	_hint_arrow.flip_v = false


func _on_hint_timer_timeout():
	if _allow_swipe_down or _allow_swipe_up:
		_hint_animation.play()
	else:
		_hint_timer.start()
