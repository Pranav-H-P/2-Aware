extends CanvasLayer



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
@onready var textBox = $Control/VBoxContainer/Panel/MarginContainer/RichTextLabel

var cutsceneActive = false

var toDisplay = []


func _ready() -> void:
	letterTimer.one_shot = true
	openBox()
	showDialog('testing [shake level=5]aaaah[/shake] oooo ........ lmao',
	"SoldierGreen", 1)

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
	

func showDialog(dialog:String, character = "SoldierGreen", basePitch = 1.0, font = "default"):
	
	toDisplay = dialog
	
	textBox.text = ""
	
	sounds.pitch_scale = basePitch
	
	textBox.text += toDisplay[textBox.text.length()]
	if toDisplay.length() > textBox.text.length() :
		letterTimer.start()
	
func getBBCodeEnclosedChar(char):
	var final = char
	if char == '[': #add bbcode processing
		final = "["
		var i = 1
		while (final[-1] != ']'):
			char = toDisplay[textBox.text.length() + i]
			final += char
			i += 1
			
		final += toDisplay[textBox.text.length() + i]
	return final
	
func _on_letter_timer_timeout() -> void:
	print("called")
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


func _on_mouse_entered() -> void:
	
	if !cutsceneActive:
		
		box.modulate = Color(1,1,1,0.8)


func _on_mouse_exited() -> void:
	
	if !(Rect2(Vector2(),$Control/VBoxContainer.size)).has_point($Control/VBoxContainer.get_local_mouse_position()):
		
		box.modulate = Color(1,1,1,1)
