extends Node3D

@onready var shoot_point: Marker3D = $ShootPoint

@export var skilldata: SkillData


const BULLET = preload("res://Characters/FireMage/fire_bolt.tscn")

func action1() -> void:
	
	var projectile = BULLET.instantiate()
	add_child(projectile)
	projectile.global_transform = shoot_point.global_transform
