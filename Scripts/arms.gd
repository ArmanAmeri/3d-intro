extends Node3D

@onready var HR: Node3D = $Skeleton3D/HolderR
@onready var HL: Node3D = $Skeleton3D/HolderL
@onready var anim: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	var HR_item = HR.get_child(0)
	if Input.is_action_pressed("shoot"):
		if anim.is_playing():
			return
		anim.play("Armature|Shoot")
		HR_item.shoot()

func equip(hand: int, item) -> void:
	var chosen_item = item.instantiate()
	if hand == 0:
		HR.add_child(chosen_item)
	elif hand == 1:
		HL.add_child(chosen_item)
	else:
		print("NON EXISTENT HAND, 0 = R, 1 = L")
