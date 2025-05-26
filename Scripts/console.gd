extends Control

@onready var input_line = $Panel/LineEdit
@onready var output_text = $Panel/TextEdit

var commands = {
	"teleport": Callable(self, "_teleport")
}

func _ready() -> void:
	visible = false

func _input(event):
	if event.is_action_pressed("toggle_console"):
		visible = not visible
		InputManager.inputs_enabled = not visible
		print(InputManager.inputs_enabled)
		if visible:
			input_line.grab_focus()

func _on_LineEdit_text_submitted(new_text):
	var parts = new_text.strip_edges().split(" ")
	var command = parts[0]
	var args = parts.slice(1, parts.size())
	if commands.has(command):
		var result = commands[command].callv(args)
		output_text.text += "\n> " + new_text + "\n" + str(result)
	else:
		output_text.text += "\n> " + new_text + "\nUnknown command."
	input_line.text = ""

func _teleport(args):
	if args.size() == 2:
		var x = args[0].to_float()
		var y = args[1].to_float()
		var player = get_node("/root/Player")
		if player:
			player.position = Vector2(x, y)
			return "Teleported to (%s, %s)" % [x, y]
		else:
			return "Player node not found."
	else:
		return "Usage: teleport x y"
