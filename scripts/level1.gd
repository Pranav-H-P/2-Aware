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
		"text": """[color=cyan]Sergeant[/color]! You're late—enough to miss the briefing!""",
		"goTo": 1,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},
	1:{
		"text": 'Settle down, everyone.',
		"goTo": 2,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},
	2:{
		"text": """Now, before we move on, let me introduce you to our new tactical asset in the field, Major -""",
		"goTo": -1,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},
	3:{
		"text": """She'll be your real-time intelligence officer""",
		"goTo": 4,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},4:{
		"text": """You'll have to brief [color=cyan]Sergeant bigshot[/color]  on the mission later""",
		"goTo": 5,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},5:{
		"text": """Understood, Commander""",
		"goTo": 6,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},6:{
		"text": """Attention, everyone! The ship has arrived. [color=cyan]Sergeant[/color], I need your unit moving immediately to the pad.""",
		"goTo": 7,
		"pitch": 0.4,
		"spriteName": 'Megaphone',
		'choice': false 
	},7:{
		"text": """I'll be returning to HQ. Sergeant, keep your comms open, stand by for updates.""",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},8:{
		"text": "Sergeant "+DataService.getUserSaveData()['name']+"? I'm Intel, It's a pleasure to meet you.",
		"goTo": 9,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},9:{
		'choice': true,
		'options':[
			{
				'text':'Major, Is your name really Intel?',
				'goTo':10
			},
			{
				'text':'What exactly is the mission?',
				'goTo':13
			},
		]
	},10:{
		"text": "Is your name really [color=red]"+DataService.getUserSaveData()['name']+"[/color]?",
		"goTo": 11,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},11:{
		"text": "I can see why he calls you [color=cyan]sergeant bigshot[/color] ",
		"goTo": 12,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},12:{
		"text": "Anyway,",
		"goTo": 13,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},13:{
		"text": "This is a two part mission. First, we need to neutralize the planetary defense platform.",
		"goTo": 14,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},14:{
		"text": "Once that asset is down, our starships will mobilize to provide enhanced logistical support and backup.",
		"goTo": 15,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},15:{
		"text": "However, before our fleet can fully support the mission, you’ll lead a unit to extract a high-value target detained in a POW camp near the platform.",
		"goTo": 16,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},16:{
		'choice': true,
		'options':[
			{
				'text':'Understood, Major',
				'goTo': 18
			},
			{
				'text':'The extraction was never mentioned before',
				'goTo':17
			},
		]
	},17:{
		"text": "HQ made a last-minute switch. Just roll with the new plan.",
		"goTo": 18,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},18:{
		"text": "The ship is here, get moving",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},
}
var currentPos = 0



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && DialogManager.box.visible:
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				DialogManager.endCutscene()
			elif next == -1:
				if $GlitchTimer.is_stopped():
					$Intel/IntelSprite.visible=true
					$Intel/SoldierSprite.visible = false
					$Intel/IntelAnim.play("intel_teleport_in")
					$Intel/Teleportation.play()
					DialogManager.showDialog("","Megaphone",0.4)
					$GlitchTimer.start()
					$GlitchEffect.startGlitch()
					LevelMusicManager.changePitch(0.3)
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
	LevelMusicManager.startMusic('level_0')
	$Intel/IntelSprite.visible=false
	$Intel/SoldierSprite.visible=true
	player.playCutsceneAnim('level_1_anim_0')

func cutsceneAnimOver(animName):
	if animName == 'level_1_anim_0':
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


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
	LevelMusicManager.changePitch(1)
	currentPos = 3
	
	var item = dialog[currentPos]

	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


func _on_intel_talk_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		currentPos = 8
		var item = dialog[currentPos]
		DialogManager.startCutscene()
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
