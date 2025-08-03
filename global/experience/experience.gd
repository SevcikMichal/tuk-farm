extends Control

@onready
var _level_label: Label = get_node("CenterContainer/Label")

func update_level(level: int) -> void:
	_level_label.text = "LVL: " + str(level)
