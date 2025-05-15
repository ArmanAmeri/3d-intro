extends Node3D
signal laser_fired()
@onready var animp: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animp.play("fire_laser")

func _emit_laser_fired() -> void:
	laser_fired.emit()




func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.taking_continuous_damage = true
		while area.taking_continuous_damage:
			area.take_damage(10)
			await get_tree().create_timer(0.1).timeout
			if is_instance_valid(area):
				continue 
			else: break


func _on_hitbox_area_exited(area: Area3D) -> void:
	if is_instance_valid(area):
		area.taking_continuous_damage = false
