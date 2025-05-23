extends Node3D

var speed : float = 80.0
var damage: int = 50

@export var lifetime: float = 3

@onready var player = get_tree().get_first_node_in_group("player")
@onready var cleanup_timer: Timer = $Timers/CleanupTimer

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_transform = player.global_transform
	var my_random_number = rng.randf_range(-360.0, 360.0)
	rotation_degrees.z = my_random_number
	cleanup_timer.start(lifetime)


func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta


func cleanup() -> void:
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
