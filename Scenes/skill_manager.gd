extends Node


@onready var arms: Node3D = $"../Head/FirstPersonCamera/Arms"


#Sukuna skills
var dismantle = preload("res://Characters/Sukuna/Attacks/dismantle.tscn")
var cleave
var dismantle_barrage
var aoe_cleave
var sp_sukuna
var ult_domain_expansion = preload("res://Scenes/malevolent_shrine.tscn")


#Average american skills
var glock = preload("res://Scenes/GUNZ/glock_19.tscn")


#Time lord skills
#some crazy ass time skills

func _process(_delta: float) -> void:
	if PlayerInfo.current_class == PlayerInfo.PlayerClasses.SUKUNA:
		use_sukuna_skillset()
	if PlayerInfo.current_class == PlayerInfo.PlayerClasses.AVERAGE_AMERICAN:
		use_averageamerican_skillset()


func use_sukuna_skillset() -> void:
	# Normal Skills
	if Input.is_action_just_pressed("skill1") and InputManager.inputs_enabled:
		arms.equip(dismantle)
	if Input.is_action_just_pressed("skill2") and InputManager.inputs_enabled:
		arms.equip(cleave)
	if Input.is_action_just_pressed("skill3") and InputManager.inputs_enabled:
		arms.equip(dismantle_barrage)
	if Input.is_action_just_pressed("skill4") and InputManager.inputs_enabled:
		arms.equip(aoe_cleave)
	
	# Special Skill
	if Input.is_action_just_pressed("special") and InputManager.inputs_enabled:
		arms.equip(sp_sukuna)
		
	# Ultimate Skill
	if Input.is_action_just_pressed("ultimate") and InputManager.inputs_enabled:
		arms.equip(ult_domain_expansion)

func use_averageamerican_skillset() -> void:
	# Normal Skills
	if Input.is_action_just_pressed("skill1") and InputManager.inputs_enabled:
		arms.equip(glock)
