extends Control

signal swipe(direction: String)

@export
var min_distance: float = 120.0

@onready
var _animation: AnimationPlayer = get_node("AnimationPlayer")

var _enabled: bool = true
var _tree_falling: bool = false
var _tracking: bool = false
var _start_pos: Vector2
var _active_pointer: int = -1
var _last_direction: int = 0  

func _ready() -> void:
	_animation.play("hint")

func _input(event: InputEvent) -> void:
	if not _enabled or _tree_falling:
		return
	
	if event is InputEventScreenTouch and event.pressed:
		_tracking = true
		_active_pointer = event.index
		_start_pos = event.position
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_tracking = true
		_active_pointer = -1
		_start_pos = event.position
		return

	if event is InputEventScreenTouch and not event.pressed and event.index == _active_pointer:
		_tracking = false
		_active_pointer = -1
		return

	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and _active_pointer == -1:
		_tracking = false
		_active_pointer = -1
		return

	if not _tracking:
		return

	if event is InputEventScreenDrag and event.index != _active_pointer:
		return

	var pos: Vector2
	if event is InputEventScreenDrag:
		pos = event.position
	elif event is InputEventMouseMotion and _active_pointer == -1:
		pos = event.position
	else:
		return

	var delta: Vector2 = pos - _start_pos

	if delta.length() < min_distance:
		return

	var dir = -1 if delta.x < 0.0 else 1
	if _last_direction == 0 or dir != _last_direction:
		emit_signal("swipe", "left" if dir == -1 else "right")
		disable()
		_last_direction = dir
		_tracking = false
		_active_pointer = -1


func _on_idle_timer_timeout() -> void:
	_animation.play("hint")

func tree_falling():
	_enabled = false
	_tree_falling = true

func tree_standing():
	_tree_falling = false
	_last_direction = 0
	_enabled = true

func enable():
	_enabled = true
	
func disable():
	_enabled = false
