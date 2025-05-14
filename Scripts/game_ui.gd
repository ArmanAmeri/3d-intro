extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hp_amount_label: Label = $ProgressBar/HpAmountLabel
@onready var enemy_count: Label = $EnemyCount

var enemies: int = 0

func _ready() -> void:
	progress_bar.max_value = player.hp_max
	hp_amount_label.text = str(player.hp)
	Signalbus.connect("anemy_created", on_anemy_created)

func _process(_delta: float) -> void:
	progress_bar.value = player.hp
	hp_amount_label.text = str(player.hp)


func on_anemy_created(current_spawns) -> void:
	enemy_count.text = str(current_spawns)
