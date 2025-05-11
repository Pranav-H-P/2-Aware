extends CanvasLayer

@onready var pauseMenu = $Control
@onready var animationPlayer = $AnimationPlayer
@onready var warningText = $Control/WarningPopup/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel
@onready var sfxVolumeSlider = $Control/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/SfxVolumeContainer/HSlider
@onready var masterVolumeSlider = $Control/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/MasterVolumeContainer/HSlider
@onready var musicVolumeSlider = $Control/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/HSlider
var dialogWasThere = false

func _ready() -> void:
	pauseMenu.visible = false
	

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("pause") && !DialogManager.cutsceneActive:

		if get_tree().paused:
			get_tree().paused = false
			DialogManager.box.visible = dialogWasThere
			if dialogWasThere:
				DialogManager.letterTimer.start()
			animationPlayer.play_backwards("pausemenu_enter")
		else:
			if DialogManager.box.visible:
				dialogWasThere = true
			DialogManager.letterTimer.stop()
			DialogManager.box.visible = false
			get_tree().paused = true
			animationPlayer.play("pausemenu_enter")



func _on_exit_pressed() -> void:
	$MenuClickAlt.play()
	warningText.text = 'Progress will be lost! Close Game?'
	animationPlayer.play('warning_enter')


func _on_close_warning_pressed() -> void:
	$MenuBack.play()
	animationPlayer.play_backwards('warning_enter')


func _on_confirm_action_pressed() -> void:
	$MenuClickAlt.play()
	if warningText.text == 'Progress will be lost! Close Game?':
		get_tree().quit()
	elif warningText.text == 'Progress will be lost! Restart Level?':
		get_tree().paused = false
		SceneService.reloadWithFade()
	else:
		get_tree().paused = false
		SceneService.changeSceneWithFade("MainMenu")
	animationPlayer.play_backwards('warning_enter')

func _on_continue_pressed() -> void:
	
	$MenuClickAlt.play()
	get_tree().paused = false
	DialogManager.box.visible = dialogWasThere
	if dialogWasThere:
		DialogManager.letterTimer.start()
	animationPlayer.play_backwards("pausemenu_enter")


func _on_menu_pressed() -> void:
	$MenuClickAlt.play()
	warningText.text = 'Progress will be lost! Exit to Menu?'
	animationPlayer.play('warning_enter')


func _on_restart_pressed() -> void:
	$MenuClickAlt.play()
	warningText.text = 'Progress will be lost! Restart Level?'
	animationPlayer.play('warning_enter')


func _on_settings_pressed() -> void:
	$MenuClickAlt.play()
	sfxVolumeSlider.value = DataService.getGlobalSettings()['sfxVolume']
	masterVolumeSlider.value = DataService.getGlobalSettings()['masterVolume']
	musicVolumeSlider.value = DataService.getGlobalSettings()['musicVolume']
	
	animationPlayer.play('settings_enter')
	


func _on_sfx_slider_value_changed(value: float) -> void:
	var busIndex = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_linear(busIndex, value)
	DataService.globalSettings['sfxVolume'] = value


func _on_music_slider_value_changed(value: float) -> void:
	var busIndex = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(busIndex, value)
	DataService.globalSettings['musicVolume'] = value


func _on_master_slider_value_changed(value: float) -> void:
	var busIndex = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(busIndex, value)
	DataService.globalSettings['masterVolume'] = value


func _on_back_pressed() -> void:
	$MenuBack.play()
	animationPlayer.play_backwards("settings_enter")
