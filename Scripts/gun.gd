extends Node3D

const BULLET = preload("res://Scenes/bullet.tscn")

@onready var timer: Timer = $Timer


func _physics_process(_delta: float) -> void:
	if timer.is_stopped():
		if Input.is_action_pressed("shoot"):
			timer.start(0.1)
			var projectile = BULLET.instantiate()
			add_child(projectile)
			projectile.global_transform = global_transform
