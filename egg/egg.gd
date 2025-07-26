extends Node3D

@export var lifetime: float = 10.0

@onready
var rigidbody: RigidBody3D = get_node("RigidBody3D")

func _ready():
	var random_force = Vector3(
		randf_range(-2, 2.0),
		randf_range(1.0, 3.0),
		randf_range(-2.0, 2.0)
	)
	
	var downward_force = Vector3(0, -3, 0)
	
	rigidbody.apply_central_impulse(downward_force)
	rigidbody.apply_torque(random_force)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()
