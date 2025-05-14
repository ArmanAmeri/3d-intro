extends Node3D

@export var spawn_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var max_spawns: int = 10
@export var spawn_range_x: float = 5.0
@export var spawn_range_z: float = 5.0
@export var infinite_spawn: bool = false

var current_spawns: int = 0
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

	if infinite_spawn:
		max_spawns = -1

func _on_timer_timeout() -> void:
	if max_spawns != -1 and current_spawns >= max_spawns:
		timer.stop()
		return

	var spawn_position = Vector3(
		randf_range(-spawn_range_x, spawn_range_x),
		0,
		randf_range(-spawn_range_z, spawn_range_z)
	)

	var instance = spawn_scene.instantiate()
	instance.position = spawn_position
	add_child(instance)

	current_spawns += 1
	Signalbus.anemy_created.emit(current_spawns)
