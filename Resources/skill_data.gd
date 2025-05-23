extends Resource
class_name  SkillData

@export_group("Limited Item")
@export var is_limited: bool = false
@export var resource_max: int
var resource: int

@export_group("Reusable Item")
@export var is_reusable: bool = false
