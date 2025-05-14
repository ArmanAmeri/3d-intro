extends CharacterBody3D

signal hurt()

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var laser_spawn: Marker3D = $LaserSpawn
@onready var check_ground: RayCast3D = $CheckGround

var max_hp: int = 100

var speed: int = 2

var nav_ready: bool = false

func _ready() -> void:
	await get_tree().process_frame
	nav_ready = true

func _physics_process(delta: float) -> void:
	if player:
		look_at(Vector3(player.position.x, player.position.y, player.position.z))
		var target = player.global_position
		var dir = Vector3(target.x - global_position.x, 0, target.z - global_position.z).normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		
	#if is_instance_valid(player) and nav_ready:
		#nav.target_position = player.global_position
		#if not nav.is_navigation_finished():
			#var next_pos = nav.get_next_path_position()
			#var dir = (next_pos - global_position).normalized()
			#velocity.x = dir.x * speed
			#velocity.z = dir.z * speed
		#else:
			#velocity.x = 0
			#velocity.z = 0
	#else:
		#if not is_instance_valid(player):
			#player = get_tree().get_first_node_in_group("player")
		#velocity.x = 0
		#velocity.z = 0
	
	
	if check_ground.is_colliding():
		velocity.y += 5 * delta
	else:
		velocity.y -= 3 * delta

	move_and_slide()


func _on_hitbox_hp_change(hp: int) -> void:
	hurt.emit()
	if hp <= 0:
		die()

func die() -> void:
	self.queue_free()
