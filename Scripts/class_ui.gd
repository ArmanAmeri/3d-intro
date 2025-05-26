extends Control

@onready var average_american_ui: Control = $AverageAmericanUI

var current_class_selected

func _ready() -> void:
	Signalbus.class_changed.connect(on_class_change)
	
	#On ready hide all unselected classes
	average_american_ui.visible = false


func on_class_change() -> void:
	current_class_selected = PlayerInfo.current_class
	
	change_to_current_class()



func change_to_current_class() -> void:
	if current_class_selected == PlayerInfo.PlayerClasses.AVERAGE_AMERICAN:
		average_american_ui.visible = true
