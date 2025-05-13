extends CharacterBody3D
class_name Player
signal hurt()
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot
@onready var thirdp_camera: Camera3D = $TwistPivot/PitchPivot/ThirdPersonCamera
@onready var firstp_camera: Camera3D = $TwistPivot/PitchPivot/FirstPersonCamera
@onready var body: Node3D = $Body
var hp_max: int = 100
var hp: int
var face_rotation
var mouse_sensivity: float = 0.001
var twist_input: float = 0.0 #horizontal
var pitch_input: float = 0.0 #vertical
# Add a flag to track if player is already dead
var is_dead: bool = false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	hp = hp_max
	is_dead = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("toggle camera"):
		toggle_camera()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (twist_pivot.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir != Vector2.ZERO:
		body.rotation_degrees.y = twist_pivot.rotation_degrees.y - rad_to_deg(input_dir.angle()) -90
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("shoot"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		-1,
		1
	)
	twist_input = 0.0
	pitch_input = 0.0
	
func take_damage(amount:int) -> void:
	# If already dead, don't take more damage
	if is_dead:
		return
		
	print(amount, " damage taken")
	hp -= amount
	
	hurt.emit()
	
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
	
func toggle_camera():
	if thirdp_camera.current == true:
		firstp_camera.make_current()
		thirdp_camera.clear_current()
	else:
		thirdp_camera.make_current()
		firstp_camera.clear_current()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
