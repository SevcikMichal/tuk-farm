extends Node3D

const FILLING_ANIMATION_NAME: String = "filling"

signal bucket_full()

## Defines the capacity of the milk bucket
@export
var capacity: float = 100

var _current_fill: float = 0
var _is_full: bool = false

@onready
var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func _add_milk(amount: float) -> void:
	if _is_full:
		return
	
	_current_fill += amount
	if _current_fill >= capacity:
		_is_full = true
		_current_fill = capacity
		emit_signal("bucket_full")
	
	_set_animation_progress(_current_fill / capacity)

func _set_animation_progress(progress: float) -> void:
	animation_player.play(FILLING_ANIMATION_NAME)
	animation_player.seek(progress, true)
	animation_player.pause()


func _on_cow_udder_milked(amount: float) -> void:
	_add_milk(amount)

func reset() -> void:
	_current_fill = 0
	_is_full = false
	_set_animation_progress(0)
