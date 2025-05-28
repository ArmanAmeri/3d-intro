extends Node

#Class Globals
enum PlayerClasses {SUKUNA, AVERAGE_AMERICAN, FIREMAGE}
var current_class : PlayerClasses

#Average American
var average_american_selected: bool = false
var max_magazines: int = 20
var current_magazines: int

func _ready() -> void:
	#Classes
	#Average American
	current_magazines = max_magazines

func change_class(changed_class: PlayerClasses) -> void:
	current_class = changed_class
	Signalbus.class_changed.emit()
