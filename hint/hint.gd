extends Control

@export
var hint_text: String

@onready
var _timer: Timer = get_node("Timer")

var _hint_label: Label

func _ready() -> void:
	_hint_label = get_node("CenterContainer/Label")
	_hint_label.text = hint_text

func _on_timer_timeout() -> void:
	_hint_label.visible = false
