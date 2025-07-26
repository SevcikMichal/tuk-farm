extends Node3D

signal throw_finished
signal hook_finished

@onready
var fishing_line: Node3D = get_node("FishingLine")

@onready
var line_start: Node3D = get_node("FishingLine/LineStart")

@onready
var line_end: Node3D = get_node("FishingLine/LineEnd")

@onready
var fishing_animation: AnimationPlayer = get_node("FishingAnimation")

var _fishing_animation_index: int = 0

func _process(_delta: float) -> void:
	update_fishing_line()
	
func update_fishing_line() -> void:
	var start_pos = line_start.position
	var end_pos = line_end.position
	var direction = end_pos - start_pos
	var length = direction.length()
	var axis = direction.normalized()

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var sides := 8
	var radius := 0.01

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

	if fishing_line.has_node("GeneratedLine"):
		var existing = fishing_line.get_node("GeneratedLine") as MeshInstance3D
		existing.mesh = mesh
		existing.transform = xform
	else:
		var line_mesh_instance = MeshInstance3D.new()
		line_mesh_instance.name = "GeneratedLine"
		line_mesh_instance.mesh = mesh
		line_mesh_instance.transform = xform
		fishing_line.add_child(line_mesh_instance)


func _on_fishing_controller_swipe_up_detected():
	fishing_animation.play("Throw")

func _on_fishing_controller_swipe_down_detected():
	fishing_animation.play("Hook")

func _on_fishing_animation_animation_finished(anim_name):
	if anim_name == "Throw":
		fishing_animation.play("Thrown_Idle")
		emit_signal("throw_finished")
	elif anim_name == "Hook":
		fishing_animation.play("Idle")
		emit_signal("hook_finished")
