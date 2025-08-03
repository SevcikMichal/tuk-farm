extends Control

@onready
var _level_label: Label = get_node("CenterContainer/VBoxContainer/Label")

@onready
var _level_progress: ProgressBar = get_node("CenterContainer/VBoxContainer/ProgressBar")

func update_level(level: int) -> void:
	_level_label.text = "LVL: " + str(level)
	
func update_progress(value: float) -> void:
	print(value)
	_level_progress.value = value
