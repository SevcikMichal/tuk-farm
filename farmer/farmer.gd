extends CharacterBody3D

const MOVEMENT_SPEED: float = 2.0

signal walk_finished(farmer_position: Vector3)

@export
var camera: Camera3D

@onready 
var _navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

@onready
var _animations: AnimationPlayer = get_node("farmer/FarmerAnimations")

func _ready() -> void:
	_navigation_agent.path_desired_distance = 0.5
	_navigation_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()

func actor_setup() -> void:
	await get_tree().physics_frame

func _unhandled_input(event) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_set_target_from_screen_position(event.position)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_set_target_from_screen_position(event.position)

func _set_target_from_screen_position(screen_pos: Vector2) -> void:
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_direction = camera.project_ray_normal(screen_pos)
	var ray_length = 1000.0

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * ray_length)
	query.collision_mask = 512

	var result = space_state.intersect_ray(query)
	if result:
		var target_pos = result.position
		_navigation_agent.set_target_position(target_pos)

func _physics_process(_delta) -> void:
	if _navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = _navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * MOVEMENT_SPEED
	
	if velocity.length() > 0.01:
		_animations.play("walk", -1, 2.0)
		look_at(global_position + velocity.normalized(), Vector3.UP)
	
	move_and_slide()

func _on_navigation_agent_3d_navigation_finished() -> void:
	_animations.play("idle")
	emit_signal("walk_finished", global_position)
