extends Control

const LOG_LIMIT: int = 10

@onready
var _debug_out: RichTextLabel = get_node("MarginContainer/RichTextLabel")

var _debug_table: Dictionary = {}
var _debug_logs: Array = []

func _process(_delta: float) -> void:
	_debug_out.clear()
	_debug_out.newline()
	_debug_out.newline()
	_debug_out.newline()
	_debug_out.newline()
	for key in _debug_table:
		_debug_out.append_text(key)
		_debug_out.append_text(": ")
		_debug_out.append_text(str(_debug_table[key]))
		_debug_out.newline()
	_debug_out.newline()
	_debug_out.newline()
	_debug_out.add_text("Logs:")
	_debug_out.newline()
	for log_line in _debug_logs:
		_debug_out.add_text(log_line)
		_debug_out.newline()

func increment_counter(key: String, increment_by: int = 1) -> void:
	if not _debug_table.has(key):
		_debug_table[key] = 0
	_debug_table[key] += increment_by

func upsert_data(key: String, value: String) -> void:
	if not _debug_table.has(key):
		_debug_table[key] = value
	_debug_table[key] = value

func log(log_message: String) -> void:
	if(_debug_logs.size() > LOG_LIMIT):
		_debug_logs.pop_front()
	_debug_logs.append(log_message)
