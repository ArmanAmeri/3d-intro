extends Node


#Class Globals

enum PlayerClasses {SUKUNA, AVERAGE_AMERICAN}
var current_class : PlayerClasses

#Average American
var average_american_selected: bool = false
var max_magazines: int = 20
var current_magazines: int


func _ready() -> void:
	#Classes
	current_class = PlayerClasses.AVERAGE_AMERICAN
	
	#Average American
	current_magazines = max_magazines

func _process(_delta: float) -> void:
	Signalbus.class_changed.emit()
