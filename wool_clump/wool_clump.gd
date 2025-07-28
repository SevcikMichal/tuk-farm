extends Node3D

signal wool_cut

@onready
var _rigidbody: RigidBody3D = get_node("RigidBody3D")

var _initial_position: Vector3
var _initial_rotation: Vector3
var _triggered := false

func _ready() -> void:
	_initial_rotation = rotation
	_initial_position = _rigidbody.position
	_rigidbody.sleeping = true
	_rigidbody.freeze = true
	visible = true

func fall_and_disappear() -> void:
	emit_signal("wool_cut")
	_rigidbody.sleeping = false
	_rigidbody.freeze = false
	
	var random_force = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(0.0, 1.0),
		0
	) * 2.0
	_rigidbody.apply_impulse(random_force)

	await get_tree().create_timer(1.0).timeout

	_rigidbody.sleeping = true
	_rigidbody.freeze = true
	_rigidbody.position = _initial_position
	_rigidbody.rotation = _initial_rotation
	visible = false
	
func reuse() -> void:
	_rigidbody.position = _initial_position
	_rigidbody.rotation = _initial_rotation
	_rigidbody.sleeping = true
	_rigidbody.freeze = true
	visible = true
	_triggered = false
	_rigidbody.input_ray_pickable = false
	await get_tree().process_frame
	_rigidbody.input_ray_pickable = true

func is_triggered() -> bool:
	return _triggered


func _on_rigid_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if _triggered:
			return
			
	if event is InputEventScreenDrag:
		_triggered = true
		fall_and_disappear()
