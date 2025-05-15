extends Node3D
signal laser_fired()

@export var laser_stay_time: float = 4.0


@onready var player: Player = $"../../../.."
@onready var animp: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


var can_be_fired: bool = true

func _ready() -> void:
	player.connect("clicked_powerful_shoot", on_laser_fired)

func on_laser_fired():
	if can_be_fired:
		animp.play("fire_laser")
		timer.start(6 + laser_stay_time)
		can_be_fired = false
		

func _emit_laser_fired() -> void:
	laser_fired.emit()


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.taking_continuous_damage = true
		while area.taking_continuous_damage:
			area.take_damage(10)
			await get_tree().create_timer(0.1).timeout
			if is_instance_valid(area):
				continue 
			else: break


func _on_hitbox_area_exited(area: Area3D) -> void:
	if is_instance_valid(area):
		area.taking_continuous_damage = false


func _on_timer_timeout() -> void:
	animp.play("laser_dissipate")
