extends CanvasLayer


signal OptionSelected(OptionData)
signal NextDialog()

const characterImages = {
	"SoldierBlue": preload("res://assets/images/BlueSoldierDialog.png"),
	"SoldierRed": preload("res://assets/images/RedSoldierDialog.png"),
	"SoldierYellow": preload("res://assets/images/YellowSoldierDialog.png"),
	"SoldierGreen": preload("res://assets/images/GreenSoldierDialog.png"),
	"SoldierPurple": preload("res://assets/images/PurpleSoldierDialog.png"),
	"IntelSideEye": preload("res://assets/images/IntelSideEyeDialog.png"),
	"IntelNormal": preload("res://assets/images/IntelSideDialog.png"),
	"IntelAngry": preload("res://assets/images/IntelAngry.png"),
	"Mark": preload("res://assets/images/MarkDialog.png")
}

const fonts = {
	"default": preload("res://assets/fonts/Jersey10-Regular.ttf"),
	"aware": preload("res://assets/fonts/Jersey20-Regular.ttf")
}

const punctTime = 0.3
const spaceTime = 0.1
const charTime = 0.05

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
	openBox()
	showOptions([
		{'text':'hi'},
		{'text':'bye'}
	])
	#showDialog('testing [shake level=5]aaaah[/shake] oooo ........ lmao',
	#"IntelNormal", 1)

func startCutscene():
	cutsceneActive = true
	get_tree().paused = true
	openBox()
	
func endCustscene():
	cutsceneActive = false
	get_tree().paused = false
	closeBox()

func openBox():
	if box.visible == false:
		animationPlayer.play("show_box")

func closeBox():
	if box.visible:
		animationPlayer.play_backwards("show_box")
	
func showOptions(optionData):
	characterSprite.texture = null
	optionBox.visible = true
	textBox.text = ""
	$Control/VBoxContainer/Panel/MarginContainer/OptionBox/Option1.text = optionData[0]['text']
	$Control/VBoxContainer/Panel/MarginContainer/OptionBox/Option2.text = optionData[1]['text']
	currentOptionData = optionData
	
func showDialog(dialog:String, character = "SoldierGreen", basePitch = 1.0, font = "default"):
	
	optionBox.visible = false
	toDisplay = dialog
	
	textBox.text = ""
	
	characterSprite.texture = characterImages[character]
	sounds.pitch_scale = basePitch
	
	letterTimer.wait_time = charTime
	if toDisplay.length() > textBox.text.length() :
		letterTimer.start()
	
func getBBCodeEnclosedChar(char):
	var final = char
	if char == '[':
		final = "["
		var i = 1
		while (final[-1] != ']'):
			char = toDisplay[textBox.text.length() + i]
			final += char
			i += 1
			
		final += toDisplay[textBox.text.length() + i]
	return final
	
func _on_letter_timer_timeout() -> void:
	var char = toDisplay[textBox.text.length()]
	var final = getBBCodeEnclosedChar(char)
	
	var basePitch = sounds.pitch_scale
	match final[-1]:
		'.','!',',','?':
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
	else:
		NextDialog.emit()

func _on_mouse_entered() -> void:
	
	if !cutsceneActive:
		
		box.modulate = Color(1,1,1,0.8)


func _on_mouse_exited() -> void:
	
	if !(Rect2(Vector2(),$Control/VBoxContainer.size)).has_point($Control/VBoxContainer.get_local_mouse_position()):
		
		box.modulate = Color(1,1,1,1)


func _on_option_1_pressed() -> void:
	OptionSelected.emit(currentOptionData[0])

func _on_option_2_pressed() -> void:
	OptionSelected.emit(currentOptionData[1])
	
