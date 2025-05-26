extends Node3D

@onready var muzzle_flash: GPUParticles3D = $ShootPoint/MuzzleFlash
@onready var shoot_point: Marker3D = $ShootPoint
@onready var ammo_display: Label3D = $AmmoDisplay
@onready var reload_audio: AudioStreamPlayer3D = $ReloadAudio
@onready var no_ammo_sound: AudioStreamPlayer3D = $NoAmmoSound
@onready var audio_shoot: AudioRandomizer = $AudioShoot


@export var skilldata: SkillData


const BULLET = preload("res://Scenes/bullet.tscn")

func _ready() -> void:
	skilldata.resource = skilldata.resource_max
	ammo_display.text = str(skilldata.resource)

func shoot() -> void:
	if skilldata.resource_empty:
		return
	
	var projectile = BULLET.instantiate()
	add_child(projectile)
	projectile.global_transform = shoot_point.global_transform
	muzzle_flash.emitting = true
	audio_shoot.play_sound()
	
	if skilldata.resource >= 1:
		skilldata.resource -= 1
	else:
		skilldata.resource_empty = true
		no_resource()
		print("Ammo empty")
	
	ammo_display.text = str(skilldata.resource)
	

func reload() -> void:
	if PlayerInfo.current_magazines <= 0:
		return
	reload_audio.play()
	skilldata.resource_empty = false
	skilldata.resource = skilldata.resource_max
	ammo_display.text = str(skilldata.resource)
	PlayerInfo.current_magazines -= 1
	Signalbus.magazine_change.emit(PlayerInfo.current_magazines)


func no_resource() -> void:
	if no_ammo_sound.playing:
		return
	no_ammo_sound.play()
