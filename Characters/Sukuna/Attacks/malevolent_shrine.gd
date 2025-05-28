extends Node3D

@export var domain_cooldown: float = 5
@export var tick_damage: int = 20
@export var tick_amount: float = 0.1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooldown_timer: Timer = $Timers/CooldownTimer

var domain_can_expand: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_ultimate():
	if not domain_can_expand:
		return
	domain_can_expand = false
	animation_player.play("ExpandDomain")
	cooldown_timer.start(animation_player.current_animation_length + domain_cooldown)
	

func _on_domain_hitbox_area_entered(area: Area3D) -> void:
	if not area.has_method("take_damage"):
		return
	
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


func _on_cooldown_timeout() -> void:
	domain_can_expand = true
