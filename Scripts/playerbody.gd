extends Node3D

@onready var original_material: StandardMaterial3D
@onready var body: MeshInstance3D = $RootNode/Rig/Skeleton3D/Mannequin
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var root_node: Node3D = $RootNode

func _ready() -> void:
	Signalbus.connect("player_hurt", on_hurt)
	# Store the original material to reset later
	if body.mesh && body.mesh.get_surface_count() > 0:
		original_material = body.mesh.surface_get_material(0).duplicate()

func _process(_delta: float) -> void:
	if player:
		if player.velocity != Vector3.ZERO:
			animation_tree.set("parameters/conditions/run", true)
			animation_tree.set("parameters/conditions/idle", false)
			#root_node.position.z = 0.3
		else:
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/idle", true)
			#root_node.position.z = 0

func on_hurt() -> void:
	if original_material:
		# Create a red material for the hurt effect
		var hurt_material = original_material.duplicate()
		if hurt_material is StandardMaterial3D:
			hurt_material.albedo_color = Color(1.0, 0.2, 0.2)  # Red color
		
		# Apply the hurt material to the body
		body.material_override = hurt_material
		
		# Create a timer to reset the material after a short duration
		var timer = get_tree().create_timer(0.15)
		timer.connect("timeout", func(): body.material_override = null)
