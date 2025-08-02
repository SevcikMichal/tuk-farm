extends CharacterBody3D

const MOVEMENT_SPEED: float = 2.0
const INTERACTION_RADIUS: float = 3.5

@onready 
var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

@export
var camera: Camera3D

@export
var cows: Node3D

@export
var sheeps: Node3D

@export
var chickens: Node3D

@export
var pond: Node3D

func _ready() -> void:
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
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
		navigation_agent.set_target_position(target_pos)

func _physics_process(_delta) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * MOVEMENT_SPEED
	
	if velocity.length() > 0.01:
		look_at(global_position + velocity.normalized(), Vector3.UP)
	
	move_and_slide()

func _check_proximity_and_act() -> void:
	var cow_dist = global_position.distance_to(cows.global_position)
	if cow_dist < INTERACTION_RADIUS:
		load_game_scene("res://cow_milking/cow_milking.tscn")

	var sheep_dist = global_position.distance_to(sheeps.global_position)
	if sheep_dist < INTERACTION_RADIUS:
		load_game_scene("res://sheep_shearing/sheep_shearing.tscn")

	var chicken_dist = global_position.distance_to(chickens.global_position)
	if chicken_dist < INTERACTION_RADIUS:
		load_game_scene("res://chicken_eggs/chicken_eggs.tscn")

	var pond_dist = global_position.distance_to(pond.global_position)
	if pond_dist < INTERACTION_RADIUS:
		load_game_scene("res://fishing/fishing.tscn")

func _on_navigation_agent_3d_navigation_finished() -> void:
	_check_proximity_and_act()

func load_game_scene(path: String) -> void:
	var scene = load(path)
	get_tree().change_scene_to_packed.call_deferred(scene)
