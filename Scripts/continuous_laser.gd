extends Node3D
signal laser_fired()
@onready var animp: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animp.play("fire_laser")

func _emit_laser_fired() -> void:
	laser_fired.emit()
