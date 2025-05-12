extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var damage: int = 25
var speed: int = 2
var player_in_hurt_box: bool = false
var damage_timer: Timer = null
var nav_ready: bool = false

func _ready() -> void:
	damage_timer = Timer.new()
	add_child(damage_timer)
	
	damage_timer.wait_time = 1.0
	damage_timer.one_shot = false
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_instance_valid(player) and nav_ready:
		nav.target_position = player.global_position
		
		if not nav.is_navigation_finished():
			var next_pos = nav.get_next_path_position()
			var dir = Vector3(
				next_pos.x - global_position.x,
				0,
				next_pos.z - global_position.z
			).normalized()
			
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		if !is_instance_valid(player):
			player = get_tree().get_first_node_in_group("player")
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		player_in_hurt_box = true
		body.take_damage(damage)
		damage_timer.start()

func _on_hurt_box_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hurt_box = false
		damage_timer.stop()

func _on_damage_timer_timeout() -> void:
	if player_in_hurt_box and is_instance_valid(player) and player.has_method("take_damage"):
		player.take_damage(damage)
