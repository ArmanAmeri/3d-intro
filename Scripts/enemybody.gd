extends MeshInstance3D

@onready var original_material: StandardMaterial3D

func _ready() -> void:
	get_parent().connect("hurt", on_hurt)

	if self.mesh && self.mesh.get_surface_count() > 0:
		original_material = self.mesh.surface_get_material(0).duplicate()

func on_hurt() -> void:
	if original_material:

		var hurt_material = original_material.duplicate()
		if hurt_material is StandardMaterial3D:
			hurt_material.albedo_color = Color(1.0, 0.2, 0.2)  # Red color
	
		self.material_override = hurt_material
		
		var timer = get_tree().create_timer(0.15)
		timer.connect("timeout", func(): self.material_override = null)
