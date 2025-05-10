extends CanvasLayer

@onready var pauseMenu = $Control
@onready var animationPlayer = $AnimationPlayer
@onready var warningText = $Control/WarningPopup/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	pauseMenu.visible = false
	

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("pause") && !DialogManager.cutsceneActive:
		if get_tree().paused:
			get_tree().paused = false
			animationPlayer.play_backwards("pausemenu_enter")
		else:
			get_tree().paused = true
			animationPlayer.play("pausemenu_enter")


func _on_exit_pressed() -> void:
	warningText.text = 'Progress will be lost! Close Game?'
	animationPlayer.play('warning_enter')


func _on_close_warning_pressed() -> void:
	animationPlayer.play_backwards('warning_enter')


func _on_confirm_action_pressed() -> void:
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
	get_tree().paused = false
	animationPlayer.play_backwards("pausemenu_enter")


func _on_menu_pressed() -> void:
	warningText.text = 'Progress will be lost! Exit to Menu?'
	animationPlayer.play('warning_enter')


func _on_restart_pressed() -> void:
	warningText.text = 'Progress will be lost! Restart Level?'
	animationPlayer.play('warning_enter')
