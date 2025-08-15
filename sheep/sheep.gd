extends Node3D

signal sheep_sheared

@onready
var _wool_clumps: Array = get_node("Wool/Clumps").get_children()

@onready
var _check_timer: Timer = get_node("Wool/CheckTimer")

@onready
var _sheep_animation: AnimationPlayer = get_node("SheepAnimations")

@onready
var _beee_sound: AudioStreamPlayer3D = get_node("BeeeSound")

func _ready():
	for wool_clump in _wool_clumps:
		wool_clump.wool_cut.connect(_on_wool_cut)

func _on_wool_cut() -> void:
	_check_timer.start()

func _on_check_timer_timeout() -> void:
	for wool_clump in _wool_clumps:
		if !wool_clump.is_triggered():
			return
	
	_play_sound(1)
	
	emit_signal("sheep_sheared")
	
	_sheep_animation.play("Respawn")
	await get_tree().create_timer(1.0).timeout
	
	for wool_clump in _wool_clumps:
		wool_clump.reuse()


func _on_sheep_animations_animation_finished(_anim_name: StringName) -> void:
	_sheep_animation.play("Idle")

func _on_timer_timeout():
	var roll = randf()
	if roll < 0.4:
		_play_sound(0)
	
func _play_sound(sound:int) -> void:
	if sound == 0:
		var pitch = randf_range(1.0, 1.5)
		_beee_sound.volume_db = -15.0
		_beee_sound.pitch_scale = pitch
		_beee_sound.play()
	if sound == 1:
		_beee_sound.volume_db = -10.0
		_beee_sound.pitch_scale = 2.0
		_beee_sound.play()
