extends Camera3D

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	Signalbus.shake_screen.connect(_camera_shake)


func _camera_shake(magnitude: float, period: float):
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform	
