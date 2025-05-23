extends Node3D

@export var domain_cooldown: float = 5
@export var domain_stay_time: float = 15
@export var tick_damage: int = 20
@export var tick_amount: float = 0.1

@onready var anim_p: AnimationPlayer = $AnimationPlayer
@onready var stay_timer: Timer = $Timers/StayTimer
@onready var cooldown_timer: Timer = $Timers/CooldownTimer
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var fpcamera = get_tree().get_first_node_in_group("fpcamera")
@onready var light = get_tree().get_first_node_in_group("light")
@onready var malevolent_line: AudioStreamPlayer = $MalevolentLine

var domain_can_expand: bool = true
var distance_behind := -13.0

func _ready() -> void:
	top_level = false
	#visible = false
	player.used_ultimate.connect(expand_domain)

func _process(_delta: float) -> void:
	if top_level == false:
		update_position()

func expand_domain():
	print("button pressed")
	if domain_can_expand:
		update_position()
		light.light_energy = 0.3
		domain_can_expand = false
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

func update_position():
	if not player or not fpcamera:
		return

	# Step 1: Get the fpcamera's *global yaw* (horizontal angle only)
	var cam_basis = fpcamera.global_transform.basis
	var cam_forward = cam_basis.z

	# Flatten and normalize it to remove any vertical pitch
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()

	# Step 2: Compute follower's target position *behind* the player, based on fpcamera yaw
	var player_pos = player.global_transform.origin
	var target_pos = player_pos - cam_forward * distance_behind
	target_pos.y = player_pos.y  # Keep follower level with the player

	global_transform.origin = target_pos

	# Step 3: Make follower face same horizontal direction as the fpcamera (no pitch)
	var look_target = target_pos + cam_forward
	look_at(look_target, Vector3.UP)

func _on_domain_hitbox_area_exited(area: Area3D) -> void:
	if is_instance_valid(area):
		area.taking_continuous_damage = false
