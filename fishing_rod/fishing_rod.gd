extends Node3D

const BASE_CHANCE: float = 0.1
const CHANCE_INCREMENT: float = 0.05
const MAX_CHANCE: float = 1.0
const MAX_FISH_DELTA_MS: int = 3000
const FISH_TO_CATCH: int = 1

signal throw_finished
signal throw_reset
signal hook_finished
signal fish_caught

@onready
var _fishing_line: Node3D = get_node("FishingLine")

@onready
var _line_start: Node3D = get_node("FishingLine/LineStart")

@onready
var _line_end: Node3D = get_node("FishingLine/LineEnd")

@onready
var _fishing_animation: AnimationPlayer = get_node("FishingAnimation")

@onready
var _fishing_timer: Timer = get_node("FishingTimer")

@onready
var _reset_timer: Timer = get_node("ResetTimer")

@onready
var _bubbles: GPUParticles3D = get_node("FishingLine/LineEnd/Bubbles")

@onready
var _fish: Node3D = get_node("FishingLine/LineEnd/Fish")

var _current_chance: float = BASE_CHANCE
var _fish_hooked_time: int = 0
var _fish_caught: int = 0

func _ready():
	_reset_timer.wait_time = MAX_FISH_DELTA_MS / 1000.0

func _process(_delta: float) -> void:
	update_fishing_line()
	
func update_fishing_line() -> void:
	var start_pos = _line_start.position
	var end_pos = _line_end.position
	var direction = end_pos - start_pos
	var length = direction.length()
	var axis = direction.normalized()

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var sides = 8
	var radius = 0.01

	for i in range(sides):
		var angle1 = TAU * i / sides
		var angle2 = TAU * (i + 1) / sides

		var p1 = Vector3(radius * cos(angle1), radius * sin(angle1), 0)
		var p2 = Vector3(radius * cos(angle2), radius * sin(angle2), 0)
		var p3 = p1 + Vector3(0, 0, -length)
		var p4 = p2 + Vector3(0, 0, -length)

		st.add_vertex(p1)
		st.add_vertex(p2)
		st.add_vertex(p3)

		st.add_vertex(p3)
		st.add_vertex(p2)
		st.add_vertex(p4)

	var mesh = st.commit()

	var mesh_basis = Basis.looking_at(axis, Vector3.UP)
	var xform = Transform3D(mesh_basis, start_pos)

	if _fishing_line.has_node("GeneratedLine"):
		var existing = _fishing_line.get_node("GeneratedLine") as MeshInstance3D
		existing.mesh = mesh
		existing.transform = xform
	else:
		var line_mesh_instance = MeshInstance3D.new()
		line_mesh_instance.name = "GeneratedLine"
		line_mesh_instance.mesh = mesh
		line_mesh_instance.transform = xform
		_fishing_line.add_child(line_mesh_instance)


func _on_fishing_controller_swipe_up_detected():
	_fishing_animation.play("Throw")

func _on_fishing_controller_swipe_down_detected():
	_reset_timer.stop()
	_bubbles.visible = false
	var actual_time = Time.get_ticks_msec()
	
	if actual_time - _fish_hooked_time <= MAX_FISH_DELTA_MS:
		_fish.set_color(get_random_warm_color())
		_fish.visible = true
		_fish_caught = _fish_caught + 1
		if _fish_caught == FISH_TO_CATCH:
			_fish_caught = 0
			emit_signal("fish_caught")
	
	_fishing_animation.play("Hook")

func _on_fishing_animation_animation_finished(anim_name):
	if anim_name == "Throw":
		_fishing_animation.play("Thrown_Idle")
		_fishing_timer.start()
	elif anim_name == "Hook":
		_fishing_animation.play("Idle")
		emit_signal("hook_finished")

func _on_fishing_timer_timeout() -> void:
	var roll = randf()
	if roll < _current_chance:
		_fishing_timer.stop()
		_reset_timer.start()
		_current_chance = BASE_CHANCE
		_fish_hooked_time = Time.get_ticks_msec()
		_fishing_animation.play("Hooked")
		_bubbles.visible = true
		emit_signal("throw_finished")
	else:
		_current_chance = min(_current_chance + CHANCE_INCREMENT, MAX_CHANCE)
		_fishing_timer.start()

func get_random_warm_color() -> Color:
	var hue = randf_range(0.0, 0.15)
	var saturation = randf_range(0.7, 1.0)
	var value = randf_range(0.8, 1.0)
	return Color.from_hsv(hue, saturation, value)


func _on_reset_timer_timeout():
	_fishing_animation.play("Thrown_Idle")
	emit_signal("throw_reset")
	_fishing_timer.start()
	_bubbles.visible = false
	_reset_timer.stop()
