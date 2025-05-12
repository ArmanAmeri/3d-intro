extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D

signal hurt()

var max_hp: int = 100
var hp: int

var damage: int = 25
var speed: int = 2
var nav_ready: bool = false
var hurtbox_colliding: bool = false

func _ready() -> void:
	hp = max_hp
	
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_instance_valid(player) and nav_ready:
		nav.target_position = player.global_position
		if not nav.is_navigation_finished():
			var next_pos = nav.get_next_path_position()
			var dir = Vector3(next_pos.x - global_position.x, 0, next_pos.z - global_position.z).normalized()
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		if not is_instance_valid(player):
			player = get_tree().get_first_node_in_group("player")
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func take_damage(amount:int) -> void:
	print(amount, " anemy damage taken")
	hp -= amount
	
	hurt.emit()
	
	if hp <= 0:
		die()

func die() -> void:
	self.queue_free()

func _on_hurt_box_body_entered(body: Node3D) -> void:
	hurtbox_colliding = true
	if body.is_in_group("player") and body.has_method("take_damage"):
		while hurtbox_colliding:
			body.take_damage(damage) 
			await get_tree().create_timer(1).timeout
			continue

func _on_hurt_box_body_exited(_body: Node3D) -> void:
	hurtbox_colliding = false
