extends Node



func _ready() -> void:
	Signalbus.escape.connect(on_escape)

func on_escape():
	if get_tree().root.has_node("InGameMenu"):
		return
	var menu = load("res://Scenes/in_game_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
