extends Control

@onready var magazine_count: Label = $MagazineCount

var current_magazine: int

func _ready() -> void:
	Signalbus.magazine_change.connect(on_mag_change)
	current_magazine = PlayerInfo.current_magazines
	magazine_count.text = str(current_magazine)

func on_mag_change(value) -> void:
	current_magazine = value
	magazine_count.text = str(current_magazine)
