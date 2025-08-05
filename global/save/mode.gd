extends Node

enum NetworkMode {
	ONLINE,
	OFFLINE
}

var _mode: NetworkMode = NetworkMode.OFFLINE
var _save_strategy: SaveStrategy

func set_mode(new_mode: NetworkMode) -> void:
	_mode = new_mode
	
func get_mode() -> NetworkMode:
	return _mode
	
func set_save_strategy(save_strategy: SaveStrategy) -> void:
	_save_strategy = save_strategy

func get_save_strategy() -> SaveStrategy:
	return _save_strategy
