extends Node2D

@onready var player = $Player
@onready var objectiveMarker = $ObjectiveMarker
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
		"text": "That was great work back there! One more stop and you'll be back home.",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},
	1:{
		'choice': true,
		'options':[
			{
				'text':'More info about the High value target',
				'goTo': 2
			},
			{
				'text':'...',
				'goTo': 7
			},
		]
	},2:{
		"text": "The target? Well... He's a high ranking official. He was pretty active at the start of the war.",
		"goTo": 3,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},3:{
		"text": "But he was captured. Nobody really knows how, but he was reported MIA back when the xenos took over K-452b.",
		"goTo": 4,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},4:{
		'choice': true,
		'options':[
			{
				'text':"How do you know he's in there?",
				'goTo': 5
			},
			{
				'text':"Why aren't they sending a full team?",
				'goTo': 6
			},
		]
	},5:{
		"text": "I've been personally working with a team to locate him, that's probably why I'm assigned to this mission",
		"goTo": 7,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},6:{
		"text": "This mission requires absolute discretion - you're the only one who can handle it.",
		"goTo": 7,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},7:{
		"text": "Anyway, we've arrived.",
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
				
			else:
				currentPos = next
				
				var item = dialog[currentPos]
				
				if item['choice']:
					DialogManager.showOptions(item['options'])
				else:
					DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
				
func _ready():
	
	player.playCutsceneAnim('walk_up')
	DialogManager.OptionSelected.connect(choiceOver)
	
	DialogManager.cutsceneActive = true
	SceneService.fadeIn()
	LevelMusicManager.startMusic('level_0')
	DialogManager.startCutscene()
	currentPos = 0
	var item = dialog[currentPos]
	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


func choiceOver(choice):
	var next = choice['goTo']
	
	if next == null:
		DialogManager.endCutscene()
	currentPos = next
	
	var item = dialog[currentPos]

	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
