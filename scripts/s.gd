extends Node2D

@onready var player = $Player
"""
1:{
		"text": 'hi2',
		"goTo": null,
		"pitch": 0.3,
		"spriteName": 'Megaphone',
		'choice': false 
	},
"""
var dialog = {
	0:{
		"text": "That's the last of them. You've really outdone yourself Sergeant",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},1:{
		"text": "Now all that's left is to extract the target. He's being detained in the room towards the front",
		"goTo": 2,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},2:{
		"text": "One thing though, I reviewed the records. He's being held in a ....",
		"goTo": 3,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},3:{
		"text": " [shake rate=30 level=20]'tar pit'[/shake]. It's [color=green]xeno[/color] technology.",
		"goTo": 4,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},4:{
		"text": "...",
		"goTo": 5,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},5:{
		"text": "It blocks all known frequencies, so I wont be able to reach you",
		"goTo": 6,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},6:{
		"text": "By the time you're back, transport will be waiting",
		"goTo": 7,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
		
	},7:{
		"text": "Let's get this over with",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	}
}
var currentPos = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && DialogManager.box.visible:
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				DialogManager.endCutscene()
			
			else:
				currentPos = next
				
				var item = dialog[currentPos]
				
				if item['choice']:
					DialogManager.showOptions(item['options'])
				else:
					DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
				
func _ready():
	player.cutsceneAnimOver.connect(cutsceneAnimOver)
	DialogManager.OptionSelected.connect(choiceOver)
	
	DialogManager.cutsceneActive = true
	SceneService.fadeIn()
	LevelMusicManager.stopMusic()
	player.playCutsceneAnim('level_23_anim_0')

func cutsceneAnimOver(animName):
	if animName == 'level_23_anim_0':
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
	

func choiceOver(choice):
	var next = choice['goTo']
	LevelMusicManager.changePitch(0.7)
	if next == null:
		LevelMusicManager.changePitch(0.4)
		DialogManager.endCutscene()
		return
	currentPos = next
	
	var item = dialog[currentPos]

	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
