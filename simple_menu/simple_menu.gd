extends Control

@onready
var _show_hints_button: CheckButton = get_node("VBoxContainer/MarginContainer2/HBoxContainer/CheckButton")

func _ready():
	_show_hints_button.button_pressed = Globals.get_configuration().show_hints()

func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)

func _on_offline_pressed() -> void:
	Mode.set_mode(Mode.NetworkMode.OFFLINE)
	Mode.set_save_strategy(OfflineSaveStrategy.new())
	load_game_scene("res://farm/farm.tscn")


func _on_check_button_toggled(toggled_on):
	Globals.get_configuration().set_show_hints(toggled_on)
	Globals.get_configuration().save_self()
