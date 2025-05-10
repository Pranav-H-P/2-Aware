extends CanvasLayer


const flashCardMessages = [
	"""[color=cyan][b]Congratulations![/b][/color]
	
	You've been selected for our exclusive closed beta!
	Your experiences and feedback will shape the future of the game.
	Feel free to contact us in case of any bugs/glitches""",
	"Live Reloading Enabled!",
	"[color=cyan][b]V2.1 Patch Details:[/b][/color]
	
	* Removed Buggy NPCs"
]

const creditsText = """
Music From [url=https://suno.com/home]SUNO[/url]

Main Menu background, Character Dialogue sprites generated using [url=https://gemini.google.com/app]Google Gemini[/url]
and pixelated using [url=https://tezumie.github.io/Image-to-Pixel/]Tezumie's Img to Pixel Tool[/url]

Specific prompts used can be found with the sourcecode

Sound Effects


Everything else by Panic Protocol
[url=https://github.com/Pranav-H-P/2-Aware]View Source Code[/url]
"""

enum buttonCardNameEnum {
	MAIN,
	SETTINGS,
	CREDITS
}

@export var lerpAnimSpeed = 5

@onready var bgImg = $BackgroundImg
@onready var animations = $AnimationPlayer
@onready var flashCard = $FlashCard
@onready var flashCardTimer = $FlashCardTimer
@onready var flashCardText = $FlashCard/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel
@onready var musicPlayer = $MainMenuMusic
@onready var menuElements = $MenuElements
@onready var creditsTextBox = $MenuElements/CreditsButtonCard/PanelContainer/MarginContainer/VBoxContainer/CreditsText
@onready var playTextButton = $MenuElements/MainButtonCard/MarginContainer/VBoxContainer/Play
@onready var deleteSaveFileButton = $MenuElements/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/DeleteSaveFile
@onready var uninstallUpdatesButton = $MenuElements/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/UninstallUpdate
@onready var masterVolumeSlider = $MenuElements/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/MasterVolumeContainer/HSlider
@onready var musicVolumeSlider = $MenuElements/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/HSlider
@onready var sfxVolumeSlider = $MenuElements/SettingsButtonCard/PanelContainer/MarginContainer/VBoxContainer/SfxVolumeContainer/HSlider
@onready var versionText = $MenuElements/TitleVersion
@onready var warningPopupText = $MenuElements/WarningPopup/PanelContainer/MarginContainer/VBoxContainer/WarningReason
@onready var playerNameInput = $MenuElements/NewGamePopup/PanelContainer/MarginContainer/VBoxContainer/PlayerName

@onready var mainButtonCard = $MenuElements/MainButtonCard
@onready var settingsButtonCard = $MenuElements/SettingsButtonCard
@onready var creditsButtonCard = $MenuElements/CreditsButtonCard
@onready var warningPopup = $MenuElements/WarningPopup
@onready var newGamePopup = $MenuElements/NewGamePopup

var outOfViewPointX; # for dynamically animating buttonCards
var cardStartPointX;

var playerName = ''

var allowedFlashcardCount = 2
var currentFlashcard = 0;

var cardAnimList: Array = []

func setupDynamicUI():
	
	playTextButton.text = 'New Game' if DataService.getUserSaveData()['level'] == 0 else 'Continue'
	versionText.text = "V2_1_Alpha" if DataService.getGlobalSettings()['patched'] else "V2_0_Alpha"
	
	deleteSaveFileButton.visible = DataService.getUserSaveData()['level'] != 0
	uninstallUpdatesButton.visible = DataService.getGlobalSettings()['patched']
	
	warningPopup.visible = false
	menuElements.visible = false
	mainButtonCard.visible = true
	settingsButtonCard.visible = true
	creditsButtonCard.visible = true
	bgImg.visible = false
	
	
	outOfViewPointX = get_viewport().size.x
	cardStartPointX = mainButtonCard.position.x
	
	creditsButtonCard.position.x = outOfViewPointX
	creditsButtonCard.modulate.a = 0.0
	settingsButtonCard.position.x = outOfViewPointX
	settingsButtonCard.modulate.a = 0.0
	creditsTextBox.text = creditsText
	
	sfxVolumeSlider.value = DataService.getGlobalSettings()['sfxVolume']
	masterVolumeSlider.value = DataService.getGlobalSettings()['masterVolume']
	musicVolumeSlider.value = DataService.getGlobalSettings()['musicVolume']
	
func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	SceneService.fadeIn()
	allowedFlashcardCount = 3 if DataService.getGlobalSettings()['patched'] else 2
	flashCard.visible = false
	showFlashCard(flashCardMessages[currentFlashcard])
	
	get_viewport().size = DisplayServer.screen_get_size()
	
	setupDynamicUI()
	



func animateButtonCard(toPos, ind, delta):
	
	var card = mainButtonCard
	var anim = cardAnimList[ind]
	var toMod = 0.0 if anim[1] == 'hide' else 1.0
	
	match anim[0]:
		buttonCardNameEnum.MAIN:
			card = mainButtonCard
		buttonCardNameEnum.SETTINGS:
			card = settingsButtonCard
		buttonCardNameEnum.CREDITS:
			card = creditsButtonCard
			
	card.position.x = lerp(
		float(card.position.x),
		float(toPos),
		lerpAnimSpeed*delta
	)
	
	card.modulate.a = lerp(
		card.modulate.a,
		toMod,
		lerpAnimSpeed*delta*5
	)
	
	if (abs(card.position.x - toPos) < 50 && abs(card.modulate.a - toMod) < 0.1):
			cardAnimList.remove_at(ind)
	
			
	
func _process(delta: float) -> void:
	
	
	for ind in range(cardAnimList.size()-1 , -1 ,-1):
		
		var toPos = outOfViewPointX if cardAnimList[ind][1] == 'hide' else cardStartPointX
	
		animateButtonCard(toPos, ind, delta)
		
	
	
	
func showFlashCard(cardData: String):
	flashCardText.text = cardData
	animations.play("flashcard_fade_in")
	

func hideFlashCard():
	animations.play("flashcard_fade_out")


func showWarningPopup(reason):
	animations.play("warning_popup_enter")
	if reason == 'SAVE':
		warningPopupText.text = 'Your Progress Will Be LOST!'
	else:
		warningPopupText.text = 'Your Progress Will Be LOST!\nOlder Bugs May Be Reintroduced!'
		
func _on_flash_card_button_pressed() -> void:
	$MenuClickAlt.play()
	currentFlashcard += 1
	hideFlashCard()

func loadMainMenu():
	animations.play('bg_fade_in')
	musicPlayer.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'flashcard_fade_out' && currentFlashcard < allowedFlashcardCount:
		showFlashCard(flashCardMessages[currentFlashcard])
	elif anim_name == 'flashcard_fade_out' && \
	currentFlashcard >= allowedFlashcardCount && \
	bgImg.visible == false:
		loadMainMenu()
	
	if anim_name == 'bg_fade_in':
		animations.play("menu_fade_in")
	
func showNewGamePopup():
	animations.play("newgame_popup_enter")

func _on_play_pressed() -> void:
	$MenuClick.play()
	if playTextButton.text == 'New Game':
		showNewGamePopup()
	else:
		SceneService.changeSceneWithFade("Level_"+str(int(DataService.getUserSaveData()['level'])))


func _on_settings_pressed() -> void:
	$MenuClick.play()
	cardAnimList.push_back([buttonCardNameEnum.SETTINGS,'show'])
	cardAnimList.push_back([buttonCardNameEnum.MAIN,'hide'])


func _on_credits_pressed() -> void:
	$MenuClick.play()
	cardAnimList.push_back([buttonCardNameEnum.CREDITS,'show'])
	cardAnimList.push_back([buttonCardNameEnum.MAIN,'hide'])


func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_back_pressed() -> void:
	$MenuBack.play()
	DataService.saveSettings()
	cardAnimList.push_back([buttonCardNameEnum.SETTINGS,'hide'])
	cardAnimList.push_back([buttonCardNameEnum.CREDITS,'hide'])
	cardAnimList.push_back([buttonCardNameEnum.MAIN,'show'])


func _on_credits_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_delete_save_file_pressed() -> void:
	$MenuClick.play()
	showWarningPopup('SAVE')


func _on_uninstall_update_pressed() -> void:
	$MenuClick.play()
	showWarningPopup('UPDATE')


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


func _on_close_warning_pressed() -> void:
	$MenuBack.play()
	animations.play("warning_popup_exit")


func _on_confirm_action_pressed() -> void:
	$MenuClickAlt.play()
	if warningPopupText.text == 'Your Progress Will Be LOST!':
		DataService.eraseAndReloadUserData()
	else:
		DataService.eraseAndReloadUserData()
		DataService.removePatch()
	animations.play("warning_popup_exit")
	get_tree().reload_current_scene()
	
	


func _on_close_new_game_pressed() -> void:
	$MenuBack.play()
	animations.play_backwards("newgame_popup_enter")


func _on_start_new_game_pressed() -> void:
	if !playerName.is_empty():
		$MenuClickAlt.play()
		DataService.userSaveData['name'] = playerName
		DataService.userSaveData['level'] = 1
		DataService.saveUserData()
		SceneService.changeSceneWithFade("Level_"+str(int(DataService.getUserSaveData()['level'])))
	else:
		playerNameInput.placeholder_text = 'Cannot Be Empty!'

func _on_player_name_text_changed(new_text: String) -> void:
	playerName = new_text.lstrip(' ').rstrip(' ')
	
