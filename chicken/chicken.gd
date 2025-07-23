extends Node3D

@onready
var squeeze_player: AnimationPlayer = get_node("Squeeze")

func _on_pitch_performed():
	squeeze_player.queue("Squeeze")
