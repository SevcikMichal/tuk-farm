extends Node3D

const FILLING_ANIMATION_NAME: String = "filling"

signal bucket_full()

## Defines the capacity of the milk bucket
@export
var capacity: float = 100

var current_fill: float = 0
var is_full: bool = false

@onready
var animation_player: AnimationPlayer = get_node("AnimationPlayer")



func _add_milk(amount: float) -> void:
	if is_full:
		return
	
	current_fill += amount
	if current_fill >= capacity:
		is_full = true
		current_fill = capacity
		emit_signal("bucket_full")
	
	_set_animation_progress(current_fill / capacity)

func _set_animation_progress(progress: float) -> void:
	animation_player.play(FILLING_ANIMATION_NAME)
	animation_player.seek(progress, true)
	animation_player.pause()


func _on_cow_udder_milked(amount: float) -> void:
	_add_milk(amount)
