extends Control

@onready var input_line = $Panel/LineEdit
@onready var output_text = $Panel/TextEdit
var player: Player

var commands = {
	"tp": Callable(self, "_teleport"),
	"spawn": Callable(self, "_spawn")
}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	visible = false
	
	Signalbus.k_toggleconsole.connect(on_toggleconsole)
	input_line.text_submitted.connect(_on_LineEdit_text_submitted)

func on_toggleconsole() -> void:
	visible = not visible
	InputManager.inputs_enabled = not visible
	if visible:
		input_line.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_LineEdit_text_submitted(new_text):
	var parts = new_text.strip_edges().split(" ")
	var command = parts[0]
	var args = parts.slice(1, parts.size())
	if commands.has(command):
		var callable = commands[command]
		if callable.is_valid():
			var result = callable.call(args)
			output_text.text += "\n> " + new_text + "\n" + str(result)
		else:
			output_text.text += "\n> " + new_text + "\nInvalid command callable."
	else:
		output_text.text += "\n> " + new_text + "\nUnknown command."

	input_line.text = ""
	output_text.scroll_vertical += 100

func _teleport(args):
	if args.size() == 4:
		var target = args[0]
		var x = args[1].to_float()
		var y = args[2].to_float()
		var z = args[3].to_float()
		
		if target == "p":
			if player:
				player.global_position = Vector3(x, y, z)
				return "Teleported to (%s, %s, %s)" % [x, y, z]
			else:
				return "Player node not found."
		else:
			return "Invalid Target"
	else:
		return "Usage: tp x y z"


func _spawn(args):
	if args.size() != 4:
		return "Usage: spawn target x y z"

	var target = args[0]
	var x = args[1].to_float()
	var y = args[2].to_float()
	var z = args[3].to_float()

	var scene_path = "res://Scenes/Entity/" + target + ".tscn"
	var scene = load(scene_path)
	if scene == null:
		return "Scene not found at path: " + scene_path

	var parent_node = get_node("/root/Main/Entities")
	if parent_node == null:
		return "Parent node '/root/Main/Entities' not found."

	var entity = scene.instantiate()
	parent_node.add_child(entity)
	entity.global_position = Vector3(x, y, z)

	return "Spawned " + target + " at (" + str(x) + ", " + str(y) + ", " + str(z) + ")"
