extends Node3D

@onready var H: Node3D = $Skeleton3D/Holder

@onready var anim: AnimationPlayer = $AnimationPlayer

var H_item

func _process(_delta: float) -> void:
	H_item = H.get_child(0)
	
	if H_item.skilldata.is_limited:
		run_limited()
	elif H_item.skilldata.is_reusable:
		run_reusable()
	else:
		print("No item in Hand")

func equip(item) -> void:
	var chosen_item = item.instantiate()
	if item:
		if H.get_child_count() <= 0:
			H.add_child(chosen_item)
		else:
			var old_item = H.get_child(0)
			H.remove_child(old_item)
	else:
		print("NO ITEM SELECTED FOR HOLDER")


func run_limited() -> void:
	if H_item:
		if Input.is_action_pressed("action1"):
			if anim.is_playing():
				return
			if H_item.skilldata.resource != 0:
				anim.play("Armature|Shoot")
				H_item.shoot()
			else:
				H_item.no_resource()
		if Input.is_action_pressed("reload"):
			if anim.is_playing():
				return
			anim.play("Armature|Reload")
			H_item.reload()
	else:
		pass

func run_reusable() -> void:
	pass
