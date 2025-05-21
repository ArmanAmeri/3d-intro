extends Node3D

@onready var muzzle_flash: GPUParticles3D = $ShootPoint/MuzzleFlash
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var shoot_point: Marker3D = $ShootPoint

const BULLET = preload("res://Scenes/bullet.tscn")


func shoot() -> void:
	var projectile = BULLET.instantiate()
	add_child(projectile)
	projectile.global_transform = shoot_point.global_transform
	muzzle_flash.emitting = true
	
	audio.play()
