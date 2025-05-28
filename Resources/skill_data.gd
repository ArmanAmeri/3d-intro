extends Resource
class_name  SkillData

@export_group("Limited Item")
@export var is_limited: bool = false
@export var resource_max: int
@export var resource: int
@export var resource_empty: bool

@export_group("Reusable Item")
@export var is_reusable: bool = false
@export_range(0.01, 1000, 0.01) var reuse_cooldown: float = 1
@export var on_cooldown: bool = false
@export var is_autostart: bool
@export var is_oneshot: bool
var cooldown_timer

func init_cooldown_timer(node_self: Node3D) -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = is_autostart
	cooldown_timer.one_shot = is_oneshot
	cooldown_timer.wait_time = reuse_cooldown
	cooldown_timer.timeout.connect(on_timeout)
	node_self.add_child(cooldown_timer)

func start_cooldown_timer(cooldown_time: float) -> void:
	if cooldown_timer:
		cooldown_timer.start(cooldown_time)
		on_cooldown = true


func on_timeout() -> void:
	on_cooldown = false
