extends Node2D

@onready var player = $Player
@onready var objMarker = $ObjectiveMarker
@onready var levelChanger = $LevelChanger
var dialog = {
	0:{
		"text": """Great work!""",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},1:{
		"text": """I've calculated a safe distance from the explosion, move to the location and and initiate the transmitter""",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	}
}

var currentDialog = 0

var killCount = 0

func _ready() -> void:
	player.cutsceneAnimOver.connect(playerAnimOver)
	SceneService.fadeIn()
	levelChanger.actionToDo = true
	LevelMusicManager.startMusic('level_1')
	

func _on_dialog_timer_timeout() -> void:
	$DialogTimer.wait_time = 6
	if currentDialog != null:
		
		DialogManager.openBox()
		
		var item = dialog[currentDialog]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		currentDialog = item['goTo']
		$DialogTimer.start()
	else:
		
		DialogManager.closeBox()

func playerAnimOver(anim_name):
	if anim_name == 'level_13_anim_0':
		DialogManager.cutsceneActive = false
		levelChanger.actionToDo = false
		DialogManager.openBox()
		$DialogTimer.wait_time = 3
		var item = dialog[currentDialog]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		objMarker.global_position = levelChanger.global_position
		currentDialog = item['goTo']
		$DialogTimer.start()

func _on_supports_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		DialogManager.cutsceneActive = true
		body.playCutsceneAnim('level_13_anim_0')
		
