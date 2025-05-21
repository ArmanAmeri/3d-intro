extends Node3D

var speed : float = 40.0
var damage: int = 50

@export var lifetime: float = 10

@onready var cleanup_timer: Timer = $Timers/CleanupTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cleanup_timer.start()

func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta


func cleanup() -> void:
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
