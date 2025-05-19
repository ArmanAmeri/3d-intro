extends Node3D
signal laser_fired()

@export var laser_stay_time: float = 5.0
@export var laser_cooldown: float = 5.0

##Damage amount for every tick
@export var tick_damage: int = 10

##Length of tick in seconds
@export var tick_length: float = 0.1

@onready var particle_effect: GPUParticles3D = $CPUParticles3D
@onready var player: Player = $"../../.."
@onready var animp: AnimationPlayer = $AnimationPlayer
@onready var laser_stay_timer: Timer = $Utilities/LaserStayTimer
@onready var cooldown_timer: Timer = $Utilities/CooldownTimer


var can_fire: bool = true


func _ready() -> void:
	player.connect("used_special", on_laser_fired)

func on_laser_fired():
	if can_fire:
		can_fire = false
		animp.play("fire_laser")
		particle_effect.emitting = true
		laser_stay_timer.start(5 + laser_stay_time)
		cooldown_timer.start(5 + laser_stay_time + laser_cooldown)
		print("fired")


func _emit_laser_fired() -> void:
	laser_fired.emit()


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.taking_continuous_damage = true
		while area.taking_continuous_damage:
			area.take_damage(tick_damage)
			await get_tree().create_timer(0.1).timeout
			if is_instance_valid(area):
				continue 
			else: break


func _on_hitbox_area_exited(area: Area3D) -> void:
	if is_instance_valid(area):
		area.taking_continuous_damage = false


func _on_laser_stay_timer_timeout() -> void:
	animp.play("laser_dissipate")


func _on_cooldown_timer_timeout() -> void:
	can_fire = true
