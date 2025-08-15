extends Node3D

const LEFT_TIT_ANIMATION_NAME: String = "left_tit"
const RIGHT_TIT_ANIMATION_NAME: String = "right_tit"

signal milked(amount: float)

@export
var good_amount: float = 5.0
@export
var great_amount: float = 10.0

@onready 
var _skeleton: Skeleton3D = get_node("Armature/Skeleton3D")

@onready
var _milk_animations: AnimationPlayer = get_node("MilkAnimations")

@onready
var _mooo_sound: AudioStreamPlayer3D = get_node("MoooSound")

@onready
var _swoosh_sound: AudioStreamPlayer3D = get_node("SwooshSound")

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
	pass


func _good_rhythm() -> void:
	emit_signal("milked", good_amount)


func _great_rhythm() -> void:
	emit_signal("milked", great_amount)


func _on_milking_controller_rhythm(state: String, last_zone: String) -> void:
	if state != "bad":
		play_sound(1)
		if last_zone == "left":
			_milk_animations.queue(LEFT_TIT_ANIMATION_NAME)
		else:
			_milk_animations.queue(RIGHT_TIT_ANIMATION_NAME)
	
	if state == "good":
		Globals.vibrate(100)
		_good_rhythm()
	elif state == "great":
		Globals.vibrate(100)
		_great_rhythm()
	elif state == "bad":
		_bad_rhythm()
		Globals.vibrate(500)

func _on_milk_bucket_bucket_full():
	_milk_animations.clear_queue()

func _on_timer_timeout():
	var roll = randf()
	if roll < 0.8:
		play_sound(0)
	
func play_sound(sound: int) -> void:
	if sound == 0:
		var pitch = randf_range(1.0, 1.5)
		_mooo_sound.pitch_scale = pitch
		_mooo_sound.play()
	if sound == 1:
		_swoosh_sound.play()
