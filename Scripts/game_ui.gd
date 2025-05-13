extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hp_amount_label: Label = $ProgressBar/HpAmountLabel

func _ready() -> void:
	progress_bar.max_value = player.hp_max
	hp_amount_label.text = str(player.hp)

func _process(_delta: float) -> void:
	progress_bar.value = player.hp
	hp_amount_label.text = str(player.hp)
