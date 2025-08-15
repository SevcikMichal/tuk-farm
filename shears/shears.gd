extends Node3D

@export
var camera: Camera3D

@onready
var _buzz_sound: AudioStreamPlayer3D = get_node("BuzzSound")

var ray_length: float = 1000.0
var debug_ray: ImmediateMesh

func _input(event) -> void:
	if event is InputEventScreenDrag:
		_move_to_finger(event.position)

func _move_to_finger(screen_pos: Vector2) -> void:
	if not _buzz_sound.playing:
		_buzz_sound.play()
	Globals.vibrate(10, 0.1)
	visible = false
	var from = camera.project_ray_origin(screen_pos)
	var to = from + camera.project_ray_normal(screen_pos) * ray_length

	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.collision_mask = 4
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)

	if result:
		visible = true
		global_transform.origin = result.position
