extends Node3D

const LEFT_TIT_ANIMATION_NAME: String = "left_tit"
const RIGHT_TIT_ANIMATION_NAME: String = "right_tit"

signal milked(amount: float)

@export
var good_amount: float = 1.0
@export
var great_amount: float = 2.0

# Attached to udder or cow
@onready 
var _skeleton: Skeleton3D = get_node("Armature/Skeleton3D")
@onready
var _milk_animations: AnimationPlayer = get_node("MilkAnimations")
@onready
var _debug: Control = %Debug

var _original_rotations = {}

func _ready():
	for bone_i in _skeleton.get_bone_count():
		_original_rotations[bone_i] = _skeleton.get_bone_pose_rotation(bone_i)

func _process(_delta: float) -> void:
	for bone_i in _original_rotations:
		var jiggle = sin(Time.get_ticks_msec() / 100.0 + bone_i) * 0.005
		var rot = _original_rotations[bone_i]
		rot.x += jiggle
		_skeleton.set_bone_pose_rotation(bone_i, rot)


func _bad_rhythm() -> void:
	_debug.upsert_data("Rhythm", "bad")
	_debug.increment_counter("Bad")


func _good_rhythm() -> void:
	emit_signal("milked", good_amount)
	_debug.upsert_data("Rhythm", "good")
	_debug.increment_counter("Good")


func _great_rhythm() -> void:
	emit_signal("milked", great_amount)
	_debug.upsert_data("Rhythm", "great")
	_debug.increment_counter("Great")


func _on_milking_controller_rhythm(state: String, last_zone: String) -> void:
	if state != "bad":
		if last_zone == "left":
			_milk_animations.queue(LEFT_TIT_ANIMATION_NAME)
		else:
			_milk_animations.queue(RIGHT_TIT_ANIMATION_NAME)
	
	if state == "good":
		_good_rhythm()
	elif state == "great":
		_great_rhythm()
	elif state == "bad":
		_bad_rhythm()
		
	
