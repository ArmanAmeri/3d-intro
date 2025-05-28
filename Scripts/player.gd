extends CharacterBody3D
class_name Player


@onready var head = $Head
@onready var camera = $Head/FirstPersonCamera
@onready var arms: Node3D = $Head/FirstPersonCamera/Arms


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

#HEALTH
var hp_max: int = 100
var hp: int

#STAMINA
var stam_max: float = 100
var stam: float
var stam_regen: float = 10
var stam_dep: float = 20

# Add a flag to track if player is already dead
var is_dead: bool = false

var input_locked: bool = false
var input_dir = Vector2.ZERO

func _ready() -> void:
	hp = hp_max
	stam = stam_max
	is_dead = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = WALK_SPEED
	
	Signalbus.k_jump.connect(on_jump)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * GRAV_AMP

	# Handle Sprint.
	if Input.is_action_pressed("sprint") and InputManager.inputs_enabled and stam > 0:
		speed = SPRINT_SPEED
		if input_dir != Vector2.ZERO:
			stam -= stam_dep * delta
			stam = max(stam, 0)
			Signalbus.player_stam_change.emit()
	else:
		speed = WALK_SPEED
		if stam < stam_max:
			stam += stam_regen * delta
			stam = min(stam, stam_max)
			Signalbus.player_stam_change.emit()

	if InputManager.inputs_enabled:
		input_dir = Input.get_vector("a", "d", "w", "s")
	else:
		input_dir = Vector2.ZERO
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
	#set_process_input(false)
	set_physics_process(false)
	
	InputManager.inputs_enabled = false
	InputManager.can_click_to_game = false
	
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

func on_jump() -> void:
	# Handle Jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
