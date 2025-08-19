extends Control

@export
var hint_text: String

@export
var hint_panel_y_size: int = 500

var _hint_label: Label
var _hint_panel: Panel

func _ready() -> void:
	_hint_panel = get_node("CenterContainer/HintPanel")
	_hint_label = get_node("CenterContainer/HintPanel/Label")
	_hint_panel.custom_minimum_size.y = hint_panel_y_size
	_hint_label.text = hint_text
	_hint_panel.visible = Globals.get_configuration().show_hints()

func _on_timer_timeout() -> void:
	_hint_panel.visible = false
