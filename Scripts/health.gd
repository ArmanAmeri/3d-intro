extends Control
class_name HealthBar

@onready var player = get_tree().get_first_node_in_group("player")
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var health_bar: TextureProgressBar = $HealthBar

var min_value : int
var max_value: int
var current_value: int


func _ready() -> void:
	Signalbus.player_hurt.connect(on_player_hurt)
	
	min_value = 0
	max_value = player.hp_max
	
	current_value = max_value
	init_bar_values(health_bar)
	init_bar_values(damage_bar)

func init_bar_values(bar: TextureProgressBar):
	bar.min_value = min_value
	bar.max_value = max_value
	bar.value = current_value

func change_current_value(value: float):
	current_value = clamp(value, min_value, max_value)
	run_juicy_tween(health_bar,current_value, 0, 0)
	run_juicy_tween(damage_bar,current_value, 0.1, 0.4)


func run_juicy_tween(bar: TextureProgressBar, value: int, length: float, delay: float ):
	var tween = get_tree().create_tween()
	tween.tween_property(bar,"value",value,length).set_delay(delay)

func on_player_hurt() -> void:
	change_current_value(player.hp)
