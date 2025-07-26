extends Control

signal pitch_performed()

@onready
var idle_timer: Timer = get_node("IdleTimer")

@onready
var animation: AnimationPlayer = get_node("AnimationPlayer")

const MIN_SWIPE_DISTANCE: int = 200
const MAX_TIME_DELTA_MS: int = 200
const RESET_TIMEOUT_MS: int = 500

var active_swipes: Dictionary = {
	"left": {"done": false, "time": 0},
	"right": {"done": false, "time": 0}
}

var start_positions: Dictionary = {}
var start_times: Dictionary = {}
var last_drag_time: int = 0

func _ready() -> void:
	animation.play("hint")

func _process(_delta: float) -> void:
	if active_swipes.left.done != active_swipes.right.done:
		var now = Time.get_ticks_msec()
		if now - last_drag_time > RESET_TIMEOUT_MS:
			_reset()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			start_positions[event.index] = event.position
			start_times[event.index] = Time.get_ticks_msec()
		else:
			start_positions.erase(event.index)
			start_times.erase(event.index)

	elif event is InputEventScreenDrag:
		last_drag_time = Time.get_ticks_msec()
		if not start_positions.has(event.index):
			start_positions[event.index] = event.position
			start_times[event.index] = Time.get_ticks_msec()
			return

		var start_pos = start_positions[event.index]
		var delta = event.position - start_pos

		if start_pos.x < size.x * 0.25 and delta.x > MIN_SWIPE_DISTANCE and not active_swipes.left.done:
			active_swipes.left.done = true
			active_swipes.left.time = Time.get_ticks_msec()

		if start_pos.x > size.x * 0.75 and delta.x < -MIN_SWIPE_DISTANCE and not active_swipes.right.done:
			active_swipes.right.done = true
			active_swipes.right.time = Time.get_ticks_msec()

		_try_emit_pitch()

func _try_emit_pitch() -> void:
	if active_swipes.left.done and active_swipes.right.done:
		var delta = abs(active_swipes.left.time - active_swipes.right.time)
		if delta <= MAX_TIME_DELTA_MS:
			animation.stop()
			idle_timer.start()
			emit_signal("pitch_performed")
		_reset()

func _reset():
	active_swipes = {
		"left": {"done": false, "time": 0},
		"right": {"done": false, "time": 0}
	}
	start_positions.clear()
	start_times.clear()


func _on_idle_timer_timeout() -> void:
	animation.play("hint")
