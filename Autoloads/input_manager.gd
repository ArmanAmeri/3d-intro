extends Node

var inputs_enabled: bool = true
var can_click_to_game: bool = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		inputs_enabled = false
		
	if Input.is_action_just_pressed("click") and can_click_to_game:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		inputs_enabled = true
	
	if inputs_enabled:
		
	
		if Input.is_action_pressed("action1"):
			#Signalbus.k_action1.emit()
			pass
		if Input.is_action_pressed("action2"):
			#Signalbus.k_action2.emit()
			pass
		if Input.is_action_pressed("jump"):
			Signalbus.k_jump.emit()
		if Input.is_action_pressed("sprint"):
			Signalbus.k_sprint.emit()
		if Input.is_action_pressed("w"):
			Signalbus.k_w.emit()
		if Input.is_action_pressed("a"):
			Signalbus.k_a.emit()
		if Input.is_action_pressed("s"):
			Signalbus.k_s.emit()
		if Input.is_action_pressed("d"):
			Signalbus.k_d.emit()
		if Input.is_action_pressed("e"):
			Signalbus.k_e.emit()
		if Input.is_action_pressed("q"):
			Signalbus.k_q.emit()
		if Input.is_action_pressed("special"):
			Signalbus.k_special.emit()
		if Input.is_action_pressed("ultimate"):
			Signalbus.k_ultimate.emit()
		if Input.is_action_pressed("reload"):
			Signalbus.k_reload.emit()
		if Input.is_action_pressed("skill1"):
			Signalbus.k_skill1.emit()
		if Input.is_action_pressed("skill2"):
			Signalbus.k_skill2.emit()
		if Input.is_action_pressed("skill3"):
			Signalbus.k_skill3.emit()
		if Input.is_action_pressed("skill4"):
			Signalbus.k_skill4.emit()
	else:
		if Input.is_action_pressed("toggle_console"):
			Signalbus.k_toggleconsole.emit()
		if Input.is_action_pressed("debugpanel"):
			Signalbus.k_debugpanel.emit()
		if Input.is_action_pressed("click"):
			Signalbus.k_click.emit()
