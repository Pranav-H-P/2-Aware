extends Node2D

@onready var player = $Player

const dialog = {
	0:{
		"text": 'hi',
		"goTo": 1,
		"pitch": 0.7,
		"spriteName": 'Megaphone',
		'choice': false 
	},
	1:{
		"text": 'hi2',
		"goTo": null,
		"pitch": 0.7,
		"spriteName": 'Megaphone',
		'choice': false 
	},
}
var currentPos = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				DialogManager.endCutscene()
			else:
				currentPos = next
				
				var item = dialog[currentPos]
				
				if item['choice']:
					DialogManager.showOptions(item)
				else:
					DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
				
func _ready():
	player.cutsceneAnimOver.connect(cutsceneAnimOver)
	SceneService.fadeIn()
	DialogManager.cutsceneActive = true
	LevelMusicManager.startMusic('level_0')
	
	player.playCutsceneAnim('level_1_anim_0')

func cutsceneAnimOver(animName):
	if animName == 'level_1_anim_0':
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


func choiceOver():
	pass
