extends CharacterBody3D

signal hurt()

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var laser_spawn: Marker3D = $LaserSpawn
@onready var projectile_node: Node3D = $ProjectileNode
@onready var timer: Node = $Timers/Timer
@onready var groundlevel: RayCast3D = $groundlevel

var max_hp: int = 100

var damage: int = 2
var speed: int = 2

var nav_ready: bool = false

func _ready() -> void:
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if player:
		look_at(Vector3(player.position.x, player.position.y, player.position.z))
	
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


func _on_hitbox_hp_change(hp: int) -> void:
	print("took damage")
	hurt.emit()
	if hp <= 0:
		die()

func die() -> void:
	self.queue_free()
