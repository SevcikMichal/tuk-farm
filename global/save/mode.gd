extends Node

enum NetworkMode {
	ONLINE,
	OFFLINE
}

var _mode: NetworkMode = NetworkMode.OFFLINE

func set_mode(new_mode: NetworkMode) -> void:
	_mode = new_mode
	
func get_mode() -> NetworkMode:
	return _mode
