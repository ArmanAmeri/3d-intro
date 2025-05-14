extends CharacterBody3D

signal hurt()

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var laser_spawn: Marker3D = $LaserSpawn
@onready var projectile_node: Node3D = $ProjectileNode
@onready var timer: Node = $Timers/Timer
@onready var groundlevel: RayCast3D = $groundlevel

var max_hp: int = 100

var laser_scene = load("res://Scenes/laser.tscn")
var enemy_direction

var float_height: float = 10.0

var damage: int = 25
var speed: int = 2
var nav_ready: bool = false

var can_shoot = true

func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING  # Set motion mode to floating
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if player:
		enemy_direction = (player.position - position).normalized()
		look_at(player.position)
		# if can_shoot:
		#     fire_laser()

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

	# Maintain floating height
	get_ground_level()
		

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

func _on_hitbox_hp_change(hp: int) -> void:
	print("took damage")
	hurt.emit()
	if hp <= 0:
		die()

func die() -> void:
	self.queue_free()

func get_ground_level() -> void:
	if groundlevel.is_colliding():
		var ground_y = groundlevel.get_collision_point().y
		var target_y = ground_y + float_height
		global_position.y = lerp(global_position.y, target_y, 0.1)
	else:
		# Fallback: Calculate distance to ground and adjust position if necessary
		var ground_distance = position.y - groundlevel.position.y
		if ground_distance > float_height:
			global_position.y = lerp(global_position.y, position.y - (ground_distance - float_height), 0.1)
