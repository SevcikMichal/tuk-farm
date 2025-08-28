extends Node3D

const CUTS_TO_FALL: int = 4
const DELAY: float = 2.0

signal tree_falling
signal fall_finished
signal tree_standing

@onready
var _animations: AnimationPlayer = get_node("AnimationPlayer")

@onready
var _crash: AudioStreamPlayer3D = get_node("Crash")

@onready
var _boom: AudioStreamPlayer3D = get_node("Boom")

var _cuts: int = 0

func cut() -> void:
	_cuts = _cuts + 1
	if _cuts >= CUTS_TO_FALL:
		_fall()

func _fall() -> void:
	emit_signal("tree_falling")
	_crash.play()
	_animations.play("fall")

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "fall":
		_crash.stop()
		_boom.play(.10)
		emit_signal("fall_finished")
		await get_tree().create_timer(DELAY).timeout
		_reset()

func _reset() -> void:
	_animations.play("RESET")
	_cuts = 0
	emit_signal.call_deferred("tree_standing")
