extends Node3D

const lazer = preload("res://Scenes/lazerv_2.tscn")

@onready var timer: Timer = $Timer

func _physics_process(_delta: float) -> void:
	if timer.is_stopped():
		timer.start(1)
		var projectile = lazer.instantiate()
		add_child(projectile)
		projectile.global_transform = global_transform
