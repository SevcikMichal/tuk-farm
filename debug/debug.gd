extends Control

@onready
var _debug_out: RichTextLabel = get_node("MarginContainer/RichTextLabel")

var _debug_table: Dictionary = {}

func _process(_delta: float) -> void:
	_debug_out.clear()
	for key in _debug_table:
		_debug_out.append_text(key)
		_debug_out.append_text(": ")
		_debug_out.append_text(str(_debug_table[key]))
		_debug_out.newline()
	pass

func increment_counter(key: String, increment_by: int = 1) -> void:
	if not _debug_table.has(key):
		_debug_table[key] = 0
	_debug_table[key] += increment_by

func upsert_data(key: String, value: String) -> void:
	if not _debug_table.has(key):
		_debug_table[key] = value
	_debug_table[key] = value
