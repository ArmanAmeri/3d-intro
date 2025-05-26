extends AudioStreamPlayer3D

class_name AudioRandomizer

@export_range(0.01, 4) var pitch_min: float = 1
@export_range(0.01, 4) var pitch_max: float = 1

var last_pitch = 1.0

func play_sound():
	randomize()
	pitch_scale = randf_range(pitch_min, pitch_max)
	
	while abs(pitch_scale - last_pitch) < .1:
		randomize()
		pitch_scale = randf_range(pitch_min, pitch_max)
	
	last_pitch = pitch_scale
	
	play()
