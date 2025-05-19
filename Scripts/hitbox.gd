extends Area3D

signal hp_change()

var hp: int
var taking_continuous_damage: bool = false

func _ready() -> void:
	hp = get_parent().max_hp

func take_damage(amount:int) -> void:

	hp -= amount
	hp_change.emit(hp)
