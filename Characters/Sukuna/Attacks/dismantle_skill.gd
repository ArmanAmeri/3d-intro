extends Node3D

var dismantle = preload("res://Characters/Sukuna/Attacks/dismantle.tscn")
@export var skilldata: SkillData
var dismantle_barrage_amount: int = 6
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	skilldata.init_cooldown_timer(self)

func action1():
	var projectile = dismantle.instantiate()
	projectile.global_transform = global_transform
	self.add_child(projectile)
	skilldata.start_cooldown_timer()

func action2():
	for i in dismantle_barrage_amount:
		var projectile = dismantle.instantiate()
		projectile.global_transform = global_transform
		projectile.position = Vector3(projectile.position.x + rng.randi_range(-1, 1), projectile.position.y + rng.randi_range(-1, 1), projectile.position.z)
		self.add_child(projectile)
		await get_tree().create_timer(0.1).timeout
	skilldata.start_cooldown_timer()
