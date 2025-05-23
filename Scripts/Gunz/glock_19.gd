extends Node3D

@onready var muzzle_flash: GPUParticles3D = $ShootPoint/MuzzleFlash
@onready var shoot_point: Marker3D = $ShootPoint
@onready var ammo_display: Label3D = $AmmoDisplay
@onready var shoot_audio: AudioStreamPlayer3D = $ShootAudio
@onready var reload_audio: AudioStreamPlayer3D = $ReloadAudio
@onready var no_ammo_sound: AudioStreamPlayer3D = $NoAmmoSound

@export var skill_data: SkillData

const BULLET = preload("res://Scenes/bullet.tscn")

const AMMO_MAX = 12

var ammo: int
var ammo_empty: bool = false

func _ready() -> void:
	ammo = AMMO_MAX
	ammo_display.text = str(ammo)

func shoot() -> void:
	if ammo_empty:
		return
	
	var projectile = BULLET.instantiate()
	add_child(projectile)
	projectile.global_transform = shoot_point.global_transform
	muzzle_flash.emitting = true
	shoot_audio.play()
	
	if ammo >= 1:
		ammo -= 1
	else:
		ammo_empty = true
		print("Ammo empty")
	
	ammo_display.text = str(ammo)
	

func reload() -> void:
	reload_audio.play()
	ammo_empty = false
	ammo = AMMO_MAX
	ammo_display.text = str(ammo)


func no_ammo() -> void:
	no_ammo_sound.play()
