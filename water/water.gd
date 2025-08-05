extends Node3D

@onready 
var _water: MeshInstance3D = get_node("Water")

@onready
var _foam: MeshInstance3D = get_node("Foam")

var _original_mesh: ArrayMesh
var _original_vertices: PackedVector3Array
var _material: Material
var _foam_material: Material

func _ready():
	_material = _water.get_active_material(0)
	_foam_material = _foam.get_active_material(0)

	var plane = _water.mesh as PlaneMesh
	var arrays = plane.get_mesh_arrays()
	_original_vertices = arrays[Mesh.ARRAY_VERTEX].duplicate()

	_original_mesh = ArrayMesh.new()
	_original_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	_original_mesh.surface_set_material(0, _material)

	_water.mesh = _original_mesh
	_water.material_override = _material
	
	var foam_mesh = ArrayMesh.new()
	foam_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _original_mesh.surface_get_arrays(0).duplicate())

	foam_mesh.surface_set_material(0, _foam_material)
	_foam.mesh = foam_mesh
	_foam.material_override = _foam_material


func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0
	var new_vertices = _original_vertices.duplicate()

	for i in new_vertices.size():
		var v = _original_vertices[i]
		var wave = sin(v.x + time) + cos(v.z + time)
		v.y = wave * 0.5
		new_vertices[i] = v

	var arrays = _original_mesh.surface_get_arrays(0)
	arrays[Mesh.ARRAY_VERTEX] = new_vertices

	_original_mesh.clear_surfaces()
	_original_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	_original_mesh.surface_set_material(0, _material)
	
	var foam_vertices = new_vertices.duplicate()
	for i in foam_vertices.size():
		var v = foam_vertices[i]
		var wave = sin(v.x + time * 1.1) + cos(v.z + time * 1.3)
		v.y = wave * 0.5 - 0.2
		foam_vertices[i] = v

	var foam_arrays = _original_mesh.surface_get_arrays(0)
	foam_arrays[Mesh.ARRAY_VERTEX] = foam_vertices

	var foam_mesh = _foam.mesh as ArrayMesh
	foam_mesh.clear_surfaces()
	foam_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, foam_arrays)
	foam_mesh.surface_set_material(0, _foam_material)
