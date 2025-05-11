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
		'choice': true,
		'options':[
			{
				'text':"Looks like there aren't any records",
				'goTo': 1
			},
			{
				'text':"There's no data on the target",
				'goTo':1
			},
		]
	},1:{
		"text": "What???",
		"goTo": -1,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},2:{
		"text": "I think you didn't use the right filters, patch me through to the system. I'll handle it",
		"goTo": 3,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},3:{
		"text": "Found it.",
		"goTo": 4,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},4:{
		"text": "Oh my god.... [shake level=20 rate=30.0]that's[/shake] how they captured him",
		"goTo": 5,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},5:{
		"text": "He's stored in the lowest level of this facility. I'll lead you there.",
		"goTo": 6,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	}, 6:{
		'choice': true,
		'options':[
			{
				'text':"You seem personally invested",
				'goTo': 7
			},
			{
				'text':"Copy that, Major",
				'goTo':null
			},
		]
	},7:{
		"text": "You sure do like to know [i]every little[/i] detail huh, Sergeant",
		"goTo": 8,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},8:{
		"text": "Reminds me of him.",
		"goTo": 9,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},9:{
		"text": "He's not just [i]any[/i] high ranking officer, he was my commanding officer.",
		"goTo": 10,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},10:{
		"text": "He was my mentor, I've known him since I first enlisted.",
		"goTo": 11,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},11:{
		"text": "So I have every damn right to be invested.",
		"goTo": 12,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},12:{
		'choice': true,
		'options':[
			{
				'text':"Understood, Major",
				'goTo': null
			},
			{
				'text':"womp woomp",
				'goTo': 13
			},
		]
	}, 13:{
		"text": "...",
		"goTo": -2,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	}
}
var currentPos = 0

var incident = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && DialogManager.box.visible:
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				DialogManager.endCutscene()
			elif next == -1:
				if $GlitchTimer.is_stopped():
					DialogManager.showDialog("","IntelSideEye",1)
					$GlitchTimer.start()
					$GlitchEffect.startGlitch()
					LevelMusicManager.changePitch(0.3)
					incident = -1
			elif next == -2:
				if $GlitchTimer.is_stopped():
					DialogManager.showDialog("","IntelAngry",1)
					
					player.ammoCount[1]=0
					player.ammoCount[2]=0
					
					$GlitchTimer.start()
					$GlitchEffect.startGlitch()
					LevelMusicManager.changePitch(0.3)
					incident = -2
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
	LevelMusicManager.startMusic('level_2')
	player.playCutsceneAnim('level_18_anim_0')

func cutsceneAnimOver(animName):
	if animName == 'level_18_anim_0':
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showOptions(item['options'])
	

func choiceOver(choice):
	var next = choice['goTo']
	
	if next == null:
		DialogManager.endCutscene()
		return
	currentPos = next
	
	var item = dialog[currentPos]

	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])



func _on_glitch_timer_timeout() -> void:
	$GlitchEffect.stopGlitch()
	if incident == -1:
		LevelMusicManager.changePitch(1)
		currentPos = 2
		
		var item = dialog[currentPos]

		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
	else:
		LevelMusicManager.changePitch(1)
		DialogManager.endCutscene()

func _on_intel_talk_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		currentPos = 8
		var item = dialog[currentPos]
		DialogManager.startCutscene()
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
