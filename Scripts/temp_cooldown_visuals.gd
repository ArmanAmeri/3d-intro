extends Control

@onready var progress1: ProgressBar = $Action1Label/ProgressBar
@onready var progress2: ProgressBar = $Action2Label/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.k_action1.connect(on_action1_used)
	Signalbus.k_action2.connect(on_action2_used)

func on_action1_used(time):
	progress1.value = progress1.max_value
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(progress1, "value", 0, time)

func on_action2_used(time):
	progress2.value = progress2.max_value
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(progress2, "value", 0, time)
 
