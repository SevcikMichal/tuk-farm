extends Node3D

signal sheep_sheared

@onready
var _wool_clumps: Array = get_node("Wool/Clumps").get_children()

@onready
var _check_timer: Timer = get_node("Wool/CheckTimer")

@onready
var _sheep_animation: AnimationPlayer = get_node("SheepAnimations")

func _ready():
	for wool_clump in _wool_clumps:
		wool_clump.wool_cut.connect(_on_wool_cut)

func _on_wool_cut() -> void:
	_check_timer.start()

func _on_check_timer_timeout() -> void:
	for wool_clump in _wool_clumps:
		if !wool_clump.is_triggered():
			return
	
	emit_signal("sheep_sheared")
	
	_sheep_animation.play("Respawn")
	await get_tree().create_timer(1.0).timeout
	
	for wool_clump in _wool_clumps:
		wool_clump.reuse()


func _on_sheep_animations_animation_finished(_anim_name: StringName) -> void:
	_sheep_animation.play("Idle")
