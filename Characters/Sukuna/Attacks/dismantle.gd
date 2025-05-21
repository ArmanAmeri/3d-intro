extends Node3D

var speed : float = 90.0
var damage: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
