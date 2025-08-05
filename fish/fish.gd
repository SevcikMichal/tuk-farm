extends Node3D

@export
var fish_scale_factor: Vector3

@onready
var _fish: Node3D = get_node("fish")

var _fish_model: MeshInstance3D

func _ready() -> void:
	_fish_model = _fish.get_node("Icosphere")
	
func set_color(color: Color) -> void:
	var material = _fish_model.get_active_material(0)
	if material == null:
		material = StandardMaterial3D.new()
	else:
		material = material.duplicate()
	
	material.albedo_color = color
	_fish_model.set_surface_override_material(0, material)
