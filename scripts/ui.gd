extends CanvasLayer




@onready var player = get_parent().get_node("Player")

@onready var shotgunPanel = $Control/MarginContainer/HealthContainer/AmmoContainer/HBoxContainer/MarginContainer2/ShotgunPanel
@onready var sniperPanel = $Control/MarginContainer/HealthContainer/AmmoContainer/HBoxContainer/MarginContainer3/SniperPanel
@onready var arPanel = $Control/MarginContainer/HealthContainer/AmmoContainer/HBoxContainer/MarginContainer/ARPanel

@onready var shotgunAmmoText = $Control/MarginContainer/HealthContainer/AmmoContainer/HBoxContainer/MarginContainer2/ShotgunPanel/HBoxContainer/ShotgunAmmo
@onready var sniperAmmoText = $Control/MarginContainer/HealthContainer/AmmoContainer/HBoxContainer/MarginContainer3/SniperPanel/HBoxContainer/SniperAmmo

@onready var healthBar = $Control/MarginContainer/HealthContainer/HealthBar
var health = 100
var ammo = [0, 0]
var ammoSelect = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	healthBar.value = health
	shotgunAmmoText.text = str(ammo[0])
	sniperAmmoText.text = str(ammo[1])
	
	arPanel.self_modulate.a = 0
	shotgunPanel.self_modulate.a = 0
	sniperPanel.self_modulate.a = 0
	
	match ammoSelect:
		0:
			arPanel.self_modulate.a = 100
		1: 
			shotgunPanel.self_modulate.a = 100
		2:
			sniperPanel.self_modulate.a = 100
	
	
func updatePlayerStats(data):
	
	health = data['health']
	ammo = data['ammo']
	ammoSelect = data['ammoSelect']
