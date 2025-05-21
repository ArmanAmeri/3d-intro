extends Node3D

@onready var HR: Node3D = $Skeleton3D/HolderR
@onready var HL: Node3D = $Skeleton3D/HolderL


func equip(hand: int, item) -> void:
	var chosen_item = item.instantiate()
	if hand == 0:
		HR.add_child(chosen_item)
	elif hand == 1:
		HL.add_child(chosen_item)
	else:
		print("NON EXISTENT HAND, 0 = R, 1 = L")
