extends Area3D

@export var scene_to_spawn: PackedScene
@export var spawn_count: int = 10

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	spawn_random_instances()

func spawn_random_instances():
	if scene_to_spawn == null:
		push_error("No scene assigned to 'scene_to_spawn'.")
		return

	var collision_shape = get_node("CollisionShape3D") as CollisionShape3D
	if collision_shape == null:
		push_error("No CollisionShape3D found.")
		return

	var shape = collision_shape.shape
	if shape == null:
		push_error("CollisionShape3D has no shape assigned.")
		return

	var area_transform = global_transform

	for i in spawn_count:
		var instance = scene_to_spawn.instantiate()
		var local_position = Vector3.ZERO

		if shape is BoxShape3D:
			var extents = shape.size * 0.5
			local_position = Vector3(
				rng.randf_range(-extents.x, extents.x),
				rng.randf_range(-extents.y, extents.y),
				rng.randf_range(-extents.z, extents.z)
			)
		elif shape is SphereShape3D:
			var radius = shape.radius
			var direction = Vector3(
				rng.randf_range(-1.0, 1.0),
				rng.randf_range(-1.0, 1.0),
				rng.randf_range(-1.0, 1.0)
			).normalized()
			var distance = rng.randf_range(0.0, radius)
			local_position = direction * distance
		else:
			push_error("Unsupported shape type for spawning.")
			continue

		var global_position = area_transform.origin + area_transform.basis * local_position
		instance.global_transform.origin = global_position
		add_child(instance)
