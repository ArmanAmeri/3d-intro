extends Node3D

@export var domain_cooldown: float = 5
@export var domain_stay_time: float = 15
@export var tick_damage: int = 20
@export var tick_amount: float = 0.1

@onready var anim_p: AnimationPlayer = $AnimationPlayer
@onready var stay_timer: Timer = $Timers/StayTimer
@onready var cooldown_timer: Timer = $Timers/CooldownTimer
@onready var player: Player = $".."
@onready var light = get_tree().get_first_node_in_group("light")
@onready var malevolent_line: AudioStreamPlayer = $MalevolentLine

var domain_can_expand: bool = true

func _ready() -> void:
	top_level = false
	visible = false
	player.used_ultimate.connect(expand_domain)

func expand_domain():
	print("button pressed")
	if domain_can_expand:
		position = Vector3(player.position.x, player.position.y, player.position.z + 13)
		malevolent_line.play()
		light.light_energy = 0.3
		domain_can_expand = false
		await get_tree().create_timer(7).timeout
		anim_p.play("domain_expansion")
		stay_timer.start(domain_stay_time)
		cooldown_timer.start(domain_stay_time + domain_cooldown)
		print("Stay timer time: ", stay_timer.wait_time)
		await get_tree().create_timer(2).timeout
		Signalbus.shake_screen.emit(0.4, domain_stay_time - 2)


func _on_stay_timer_timeout() -> void:
	anim_p.play("domain_reduction")
	light.light_energy = 1


func _on_cooldown_timer_timeout() -> void:
	print("cooldonw timed out")
	domain_can_expand = true
	top_level = true


func _on_domain_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.taking_continuous_damage = true
		while area.taking_continuous_damage:
			area.take_damage(tick_damage)
			await get_tree().create_timer(tick_amount).timeout
			if is_instance_valid(area):
				continue 
			else: break


func _on_domain_hitbox_area_exited(area: Area3D) -> void:
	if is_instance_valid(area):
		area.taking_continuous_damage = false
