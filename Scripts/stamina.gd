extends Control
class_name StaminaBar

@onready var player = get_tree().get_first_node_in_group("player")
@onready var drain_bar: TextureProgressBar = $DrainBar
@onready var stamina_bar: TextureProgressBar = $StaminaBar

var min_value : float
var max_value: float
var current_value: float
var last_value: float

var long_delay: float = 0.4
var short_delay: float = 0

var stam_delay: float
var drain_delay: float


func _ready() -> void:
	Signalbus.player_stam_change.connect(on_player_stam_change)
	
	min_value = 0
	max_value = player.stam_max
	
	stam_delay = short_delay
	drain_delay = long_delay
	
	last_value = max_value
	current_value = max_value
	init_bar_values(stamina_bar)
	init_bar_values(drain_bar)

func init_bar_values(bar: TextureProgressBar):
	bar.min_value = min_value
	bar.max_value = max_value
	bar.value = current_value

func change_current_value(value: float):
	if value < last_value:
		stam_delay = short_delay
		drain_delay = long_delay
	elif value > last_value:
		stam_delay = long_delay
		drain_delay = short_delay
	current_value = clamp(value, min_value, max_value)
	run_juicy_tween(stamina_bar,current_value, 0, stam_delay)
	run_juicy_tween(drain_bar,current_value, 0.1, drain_delay)
	last_value = value

func run_juicy_tween(bar: TextureProgressBar, value: float, length: float, delay: float ):
	var tween = get_tree().create_tween()
	tween.tween_property(bar,"value",value,length).set_delay(delay)

func on_player_stam_change() -> void:
	change_current_value(player.stam)
