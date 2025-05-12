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
		"text": "Where's Mark?",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	},1:{
		'choice': true,
		'options':[
					{
						'text':"....",
						'goTo': 2
					},
					{
						'text':"He attacked me, I had no choice",
						'goTo':2
					},
				]
	
	},2:{
		"text": " [shake rate=30 level=20]. . . . .[/shake] ",
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
