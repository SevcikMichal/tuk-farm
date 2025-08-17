class_name Configuration

const CONFIGURATION_SAVE_PATH: String = "user://configuration.dat"

var _show_hints: bool = true
var _is_haptics_enabled: bool = true

func _init(show_hints_in: bool = true) -> void:
	_show_hints = show_hints_in
	
func toggle_show_hints() -> bool:
	_show_hints = !_show_hints
	return _show_hints

func toggle_is_haptics_enabled() -> bool:
	_is_haptics_enabled = !_is_haptics_enabled
	return _is_haptics_enabled

func show_hints() -> bool:
	return _show_hints
	
func is_haptics_enabled() -> bool:
	return _is_haptics_enabled

func save_self() -> void:
	var json = JSON.stringify(to_dict())
	
	var file = FileAccess.open(CONFIGURATION_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json)
	
	file.close()

func load_self() -> void:
	if not FileAccess.file_exists(CONFIGURATION_SAVE_PATH):
		return
	
	var file = FileAccess.open(CONFIGURATION_SAVE_PATH, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json)
	
	file.close()
	
	from_dict(data)
	
func to_dict() -> Dictionary:
	return {
		"show_hints": _show_hints,
		"is_haptics_enabled": _is_haptics_enabled
	}

func from_dict(data: Dictionary) -> void:
	_show_hints = data.get("show_hints", true)	
	_is_haptics_enabled = data.get("is_haptics_enabled", true)
