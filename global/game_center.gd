extends Node

var _game_center: Object = null

func _ready():
	if Engine.has_singleton("GameCenter"):
		_game_center = Engine.get_singleton("GameCenter")
	else:
		print("iOS Game Center plugin is not available on this platform.")

func authenticate() -> void:
	if _can_execute():
		_game_center.authenticate()

func post_score(score: float, category: String) -> void:
	if _can_execute() and _game_center.is_authenticated():
		print("Posting Score")
		_game_center.post_score({ "score": score, "category": category })

func show_game_center() -> void:
	if _can_execute() and _game_center.is_authenticated():
		_game_center.show_game_center({})

func is_authenticated() -> bool:
	if _can_execute():
		return _game_center.is_authenticated()
	return false

func _can_execute() -> bool:
	return Mode.get_mode() == Mode.NetworkMode.ONLINE and _game_center != null
