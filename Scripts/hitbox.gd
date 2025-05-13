extends Area3D

signal hp_change()

var hp: int

func _ready() -> void:
	hp = get_parent().max_hp

func take_damage(amount:int) -> void:
	print(amount, " anemy damage taken")
	hp -= amount
	
	hp_change.emit(hp)
