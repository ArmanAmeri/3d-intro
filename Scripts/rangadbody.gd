extends Node3D

@onready var face: MeshInstance3D = $Eye
@onready var body: MeshInstance3D = $Body
@onready var original_material: StandardMaterial3D

func _ready() -> void:
	get_parent().connect("hurt", on_hurt)
	# Store the original material to reset later
	if body.mesh && body.mesh.get_surface_count() > 0:
		original_material = body.mesh.surface_get_material(0).duplicate()

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
