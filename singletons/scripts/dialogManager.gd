extends CanvasLayer


signal OptionSelected(OptionData)

const characterImages = {
	"SoldierBlue": preload("res://assets/images/BlueSoldierDialog.png"),
	"SoldierRed": preload("res://assets/images/RedSoldierDialog.png"),
	"SoldierYellow": preload("res://assets/images/YellowSoldierDialog.png"),
	"SoldierGreen": preload("res://assets/images/GreenSoldierDialog.png"),
	"SoldierPurple": preload("res://assets/images/PurpleSoldierDialog.png"),
	"IntelSideEye": preload("res://assets/images/IntelSideEyeDialog.png"),
	"IntelNormal": preload("res://assets/images/IntelSideDialog.png"),
	"IntelAngry": preload("res://assets/images/IntelAngry.png"),
	"Mark": preload("res://assets/images/MarkDialog.png"),
	"Megaphone": preload("res://assets/images/MegaphonePixelated.png")
}

const fonts = {
	"default": preload("res://assets/fonts/Jersey10-Regular.ttf"),
	"aware": preload("res://assets/fonts/Jersey20-Regular.ttf")
}

const punctTime = 0.1
const spaceTime = 0.07
const charTime = 0.025

@onready var box =  $Control
@onready var animationPlayer = $AnimationPlayer
@onready var letterTimer = $LetterTimer
@onready var sounds = $SpeechSoundEffect
@onready var textBox = $Control/VBoxContainer/Panel/MarginContainer/RegularText
@onready var optionBox = $Control/VBoxContainer/Panel/MarginContainer/OptionBox
@onready var characterSprite = $Control/VBoxContainer/MarginContainer/TextureRect

var cutsceneActive = false

var toDisplay = []

var currentOptionData = [
	{
		"text": 'optn 1',
		"goTo": 0
	},
	{
		"text": 'optn 2',
		"goTo": 0
	}
]

func _ready() -> void:
	letterTimer.one_shot = true
	

func startCutscene():
	cutsceneActive = true
	get_tree().paused = true
	openBox()
	
func endCutscene():
	cutsceneActive = false
	get_tree().paused = false
	letterTimer.stop()
	closeBox()

func openBox():
	if box.visible == false:
		animationPlayer.play("show_box")

func closeBox():
	if box.visible:
		animationPlayer.play_backwards("show_box")
	
func showOptions(optionData):
	letterTimer.stop()
	characterSprite.texture = null
	optionBox.visible = true
	textBox.text = ""
	$Control/VBoxContainer/Panel/MarginContainer/OptionBox/Option1.text = optionData[0]['text']
	$Control/VBoxContainer/Panel/MarginContainer/OptionBox/Option2.text = optionData[1]['text']
	currentOptionData = optionData
	
func showDialog(dialog:String, spriteName = "SoldierGreen", basePitch = 1.0):
	
	letterTimer.stop()
	optionBox.visible = false
	toDisplay = dialog
	
	textBox.text = ""
	
	if spriteName.contains("Intel"):
		textBox.add_theme_font_override('bold_font',fonts['aware'])
		textBox.add_theme_font_override('normal_font',fonts['aware'])
		textBox.add_theme_font_override('italics_font',fonts['aware'])
	else:
		textBox.add_theme_font_override('bold_font',fonts['default'])
		textBox.add_theme_font_override('normal_font',fonts['default'])
		textBox.add_theme_font_override('italics_font',fonts['default'])
		
	characterSprite.texture = characterImages[spriteName]
	sounds.pitch_scale = basePitch
	
	letterTimer.wait_time = charTime
	if toDisplay == "":
		return
	if toDisplay.length() > textBox.text.length() :
		letterTimer.start()
	
func getBBCodeEnclosedChar(ch):
	var final = ch
	if ch == '[':
		final = "["
		var i = 1
		while (final[-1] != ']'):
			ch = toDisplay[textBox.text.length() + i]
			final += ch
			i += 1
			
		final += toDisplay[textBox.text.length() + i]
	return final
	
func _on_letter_timer_timeout() -> void:
	if textBox.text.length() >= toDisplay.length():
		return
	var ch = toDisplay[textBox.text.length()]
	var final = getBBCodeEnclosedChar(ch)
	
	var basePitch = sounds.pitch_scale
	match final[-1]:
		'.','!',',','?','-':
			letterTimer.wait_time = punctTime
		' ':
			letterTimer.wait_time = spaceTime
		_:
			if final[-1] in ['a','e','i','o','u']:
				
				sounds.pitch_scale += RngService.random.randf_range(-0.4,0.4)
				
			letterTimer.wait_time = charTime
			sounds.play()
	sounds.pitch_scale = basePitch
			
	textBox.text += final
	
	
	if textBox.text.length() < toDisplay.length():
		letterTimer.start()

func _on_mouse_entered() -> void:
	
	if !cutsceneActive:
		
		box.modulate = Color(1,1,1,0.5)


func _on_mouse_exited() -> void:
	
	if !(Rect2(Vector2(),$Control/VBoxContainer.size)).has_point($Control/VBoxContainer.get_local_mouse_position()):
		
		box.modulate = Color(1,1,1,1)


func _on_option_1_pressed() -> void:
	OptionSelected.emit(currentOptionData[0])

func _on_option_2_pressed() -> void:
	OptionSelected.emit(currentOptionData[1])
	
