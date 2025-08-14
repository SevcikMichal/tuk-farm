extends AudioStreamPlayer3D



func _on_timer_timeout():
	var roll = randf()
	if roll < 0.6:
		var random_pitch = randf_range(0.5, 0.55)
		pitch_scale = random_pitch
		play()
