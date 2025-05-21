extends CharacterBody3D
class_name Player

signal used_special()
signal used_ultimate()

@onready var head = $Head
@onready var camera = $Head/FirstPersonCamera
@onready var continuous_laser: Node3D = $Head/FirstPersonCamera/ContinuousLaser
@onready var arms: Node3D = $Head/FirstPersonCamera/Arms

var glock19 = preload("res://Scenes/GUNZ/glock_19.tscn")

var gravity: float = 9.8
const GRAV_AMP = 1.35
const AIR_FRICTION = 1.25

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.001

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
const A_BOB_AMP = 0.02
var t_bob = 0.0
var a_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var hp_max: int = 100
var hp: int

# Add a flag to track if player is already dead
var is_dead: bool = false


func _ready() -> void:
	continuous_laser.visible = false
	hp = hp_max
	is_dead = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#arms.equip(0, glock19)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * GRAV_AMP
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed / AIR_FRICTION, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed / AIR_FRICTION, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob, "camera")
	
	# Arm bob
	a_bob += delta * velocity.length() * float(is_on_floor())
	arms.transform.origin = _headbob(a_bob, "arms")
	
	#Mouse Lock
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("shoot"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("Special"):
		used_special.emit()
		continuous_laser.visible = true
	
	if Input.is_action_just_pressed("ultimate"):
		used_ultimate.emit()
		print("pressed B")
		#make domain visible here
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
func take_damage(amount:int) -> void:
	# If already dead, don't take more damage
	if is_dead:
		return
	hp -= amount
	
	Signalbus.player_hurt.emit()
	
	if hp <= 0:
		die()
		
func die() -> void:
	# Check if already dead to prevent multiple death overlays
	if is_dead:
		return
		
	# Mark as dead
	is_dead = true
	
	print("Player died!")
	
	# Disable player controls
	set_process_input(false)
	set_physics_process(false)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Instance the death overlay scene
	var death_overlay = preload("res://Scenes/you_died.tscn").instantiate()
	
	# Add it to the scene tree
	get_tree().root.add_child(death_overlay)
	



func _unhandled_input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _headbob(time, type: String) -> Vector3:
	var pos = Vector3.ZERO
	if type == "camera":
		pos.y = sin(time * BOB_FREQ) * BOB_AMP
		pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	elif type == "arms":
		pos.y = sin(time * BOB_FREQ ) * A_BOB_AMP
		pos.x = cos(time * BOB_FREQ / 2) * A_BOB_AMP
	return pos
