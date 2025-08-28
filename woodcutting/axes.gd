extends Node3D

@onready
var _axe_left: Node3D = get_node("AxeL")

@onready
var _axe_right: Node3D = get_node("AxeR")

func _on_wood_cutting_controller_swipe(direction):
	if direction == "right":
		_axe_left.swing()
	else:
		_axe_right.swing()
