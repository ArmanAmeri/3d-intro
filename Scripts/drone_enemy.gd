extends CharacterBody3D

signal hurt()

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var laser_spawn: Marker3D = $LaserSpawn
@onready var projectile_node: Node3D = $ProjectileNode
@onready var timer: Node = $Timers/Timer

var max_hp: int = 100
var hp: int

var laser_scene = load("res://Scenes/laser.tscn")
var enemy_direction

var damage: int = 25
var speed: int = 2
var nav_ready: bool = false
var hurtbox_colliding: bool = false
var can_shoot = true

func _ready() -> void:
	hp = max_hp
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if player:
		enemy_direction = (player.position - position).normalized()
		look_at(Vector3(player.position.x, 0, player.position.z))
		if can_shoot:
			fire_laser()
	if position.y >= 50:
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


func fire_laser():
	var laser_shot = laser_scene.instantiate()
	laser_shot.position = laser_spawn.global_position
	laser_shot.rotation = self.rotation
	laser_shot.direction = Vector3.FORWARD
	projectile_node.add_child(laser_shot)
	can_shoot = false
	timer.start(2)



func _reload_timeout() -> void:
	can_shoot = true
	

func take_damage(amount:int) -> void:
	print(amount, " anemy damage taken")
	hp -= amount
	
	hurt.emit()
	
	if hp <= 0:
		die()

func die() -> void:
	self.queue_free()
