extends Node3D

const FILLING_ANIMATION_NAME: String = "filling"

signal bucket_full()

## Defines the capacity of the milk bucket
@export
var capacity: float = 100

var _current_fill: float = 0
var _is_full: bool = false

@onready
var _animation_player: AnimationPlayer = get_node("AnimationPlayer")

@onready
var _blub_blub_sound: AudioStreamPlayer3D = get_node("Milk/BlubBlubSound")

func _add_milk(amount: float) -> void:
	if _is_full:
		return
	
	_blub_blub_sound.play.call_deferred()
	
	_current_fill += amount
	if _current_fill >= capacity:
		_is_full = true
		_current_fill = capacity
		emit_signal("bucket_full")
		_reset()
		
	_set_animation_progress(_current_fill / capacity)

func _set_animation_progress(progress: float) -> void:
	_animation_player.play(FILLING_ANIMATION_NAME)
	_animation_player.seek(progress, true)
	_animation_player.pause()


func _on_cow_udder_milked(amount: float) -> void:
	_add_milk(amount)

func _reset() -> void:
	_current_fill = 0
	_is_full = false
	_set_animation_progress(0)
