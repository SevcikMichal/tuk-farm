extends Node3D

@onready
var _right_foot_sound: AudioStreamPlayer3D = get_node("Armature/Skeleton3D/RightFoot/Node3D/AudioStreamPlayer3D")

@onready
var _left_foot_sound: AudioStreamPlayer3D = get_node("Armature/Skeleton3D/LeftFoot/Node3D/AudioStreamPlayer3D")


func play_step(right: bool):
	if right:
		_right_foot_sound.play()
	else:
		_left_foot_sound.play()
