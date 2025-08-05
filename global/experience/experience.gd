extends Control

@onready
var _level_label: Label = get_node("CenterContainer/VBoxContainer/Label")

@onready
var _level_progress: ProgressBar = get_node("CenterContainer/VBoxContainer/ProgressBar")

@onready
var _level_celebration: CPUParticles2D = get_node("CPUParticles2D")

func update_level(level: int) -> void:
	_level_label.text = str(level)
	_celebrate()
	
func update_progress(value: float) -> void:
	_level_progress.value = value

func _celebrate() -> void:
	_level_celebration.emitting = true
