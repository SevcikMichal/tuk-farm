extends Node3D

@onready
var _milk_bucket: Node3D = $MilkBucket

@onready
var _debug: Control = %Debug

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:
			if _debug != null:
				_debug.increment_counter("CowMilked")
			_milk_bucket.add_milk(1.0)
