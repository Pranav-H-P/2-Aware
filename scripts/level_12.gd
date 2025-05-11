extends Node2D


var dialog = {
	0:{
		"text": """The platform is up ahead, you'll have to plant explosives at the supports""",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},
}

var currentDialog = 0

var killCount = 0

func _ready() -> void:
	
	SceneService.fadeIn()
	LevelMusicManager.startMusic('level_1')
	
	$DialogTimer.start(2)

func _on_dialog_timer_timeout() -> void:
	$DialogTimer.wait_time = 4
	if currentDialog != null:
		
		DialogManager.openBox()
		
		var item = dialog[currentDialog]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		currentDialog = item['goTo']
		$DialogTimer.start()
	else:
		DialogManager.closeBox()
