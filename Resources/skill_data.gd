extends Resource
class_name  SkillData

@export_group("Limited Item")
@export var is_limited: bool = false
@export var resource_max: int
@export var resource: int
@export var resource_empty: bool

@export_group("Reusable Item")
@export var is_reusable: bool = false
@export_range(0.1, 1000, 0.1) var reuse_cooldown: float = 1
