extends Node3D

var timer: Timer

func _ready() -> void:
	visible = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.03
	timer.connect("timeout", _on_timer_timeout)
	
	timer.start()

func _on_timer_timeout() -> void:
	visible = true
