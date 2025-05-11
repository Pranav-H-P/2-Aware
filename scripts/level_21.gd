extends Node2D


var dialog = {
	0:{
		"text": """This is it, it's the final stretch""",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},1:{
		"text": """They know what we're doing. They're sending in a massive wave.""",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	}
}

var currentDialog = 0

var killCount = 0

func _ready() -> void:
	
	SceneService.fadeIn()
	LevelMusicManager.stopMusic()
	
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
