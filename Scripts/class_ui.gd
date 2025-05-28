extends Control

@onready var average_american_ui: Control = $AverageAmericanUI

func _ready() -> void:
	Signalbus.class_changed.connect(on_class_change)
	
	#On ready hide all unselected classes
	average_american_ui.visible = false
	
	on_class_change()

func on_class_change() -> void:	
	if PlayerInfo.current_class == PlayerInfo.PlayerClasses.AVERAGE_AMERICAN:
		average_american_ui.visible = true
