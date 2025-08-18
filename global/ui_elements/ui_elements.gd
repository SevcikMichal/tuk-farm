extends Control

@export
var show_home_button: bool = true

@export
var show_level_progress: bool = true

@export
var show_simple_menu: bool = false

@onready
var _level_label: Label = get_node("Experience/VBoxContainer/ProgressBar/Label")

@onready
var _level_progress: ProgressBar = get_node("Experience/VBoxContainer/ProgressBar")

@onready
var _level_celebration: CPUParticles2D = get_node("ExperienceParticles")

@onready
var _celebrate_sound: AudioStreamPlayer = get_node("ExperienceCelebration")

@onready
var _click_sound: AudioStreamPlayer = get_node("ClickSound")

@onready
var _options_container: CenterContainer = get_node("GeneralPanel/Options")

@onready 
var _home_button: Button = get_node("GeneralPanel/TopPanel/Home")

@onready
var _simple_menu: VBoxContainer = get_node("SimpleMenu")

@onready
var _game_title_panel: Panel = get_node("GameTitlePanel")

@onready
var _game_title: Label = get_node("GameTitlePanel/GameTitle")

@onready
var _haptics_indicator: ColorRect = get_node("GeneralPanel/Options/CenterContainer/Vertical/Haptics/Indicator")

@onready
var _hints_indicator: ColorRect = get_node("GeneralPanel/Options/CenterContainer/Vertical/Hints/Indicator")

@onready
var _sounds_indicator: ColorRect = get_node("GeneralPanel/Options/CenterContainer/Vertical/Sounds/Indicator")

func _ready():
	_level_progress.visible = show_level_progress
	_home_button.visible = show_home_button
	_simple_menu.visible = show_simple_menu
	_game_title_panel.visible = show_simple_menu
	_hints_indicator.color = Color.DARK_GREEN if Globals.get_configuration().show_hints() else Color.DARK_RED
	_haptics_indicator.color = Color.DARK_GREEN if Globals.get_configuration().is_haptics_enabled() else Color.DARK_RED
	_sounds_indicator.color = Color.DARK_GREEN if Globals.get_configuration().is_sound_enabled() else Color.DARK_RED
	_game_title.label_settings.outline_color = Color(randf(), randf(), randf())
	
func _on_show_options_pressed():
	_button_pressed_feedback()
	_options_container.visible = !_options_container.visible
	_options_container.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_home_pressed():
	_button_pressed_feedback()
	_load_game_scene("res://farm/farm.tscn")

func _on_hints_button_pressed():
	_button_pressed_feedback()
	var res = Globals.get_configuration().toggle_show_hints()
	_hints_indicator.color = Color.DARK_GREEN if res else Color.DARK_RED
	Globals.get_configuration().save_self()

func _on_haptics_button_pressed():
	_button_pressed_feedback()
	var res = Globals.get_configuration().toggle_is_haptics_enabled()
	_haptics_indicator.color = Color.DARK_GREEN if res else Color.DARK_RED
	Globals.get_configuration().save_self()

func _on_sounds_pressed():
	_button_pressed_feedback()
	var res = Globals.get_configuration().toggle_is_sound_enabled()
	if res:
		Globals.unmute_sound()
	else:
		Globals.mute_sound()
	_sounds_indicator.color = Color.DARK_GREEN if res else Color.DARK_RED
	Globals.get_configuration().save_self()


func _on_offline_pressed() -> void:
	_button_pressed_feedback()
	Mode.set_mode(Mode.NetworkMode.OFFLINE)
	Mode.set_save_strategy(OfflineSaveStrategy.new())
	_load_game_scene("res://farm/farm.tscn")

func _button_pressed_feedback() -> void:
	Globals.vibrate(Globals.BUTTON_PRESSED_VIBRATION_DURATION_MS)
	_click_sound.play_click()

func _load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)	

func update_level(level: int, celebrate: bool = true) -> void:
	_level_label.text = str(level)
	if celebrate:
		_celebrate()
	
func update_progress(value: float) -> void:
	_level_progress.value = value

func _celebrate() -> void:
	_level_celebration.emitting = true
	_celebrate_sound.play()
	Globals.vibrate(1000)
