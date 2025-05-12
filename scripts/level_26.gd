extends Node2D

@onready var player = $Player
@onready var intelHealth = $CanvasLayer/IntelHealth
@onready var intel = $Intel
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
		"text": " [shake rate=30 level=20]DO YOU HAVE ANY IDEA WHO HE WAS?[/shake] ",
		"goTo": 1,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},1:{
		"text": " [shake rate=30 level=20]This is just a game for you, isn't it?[/shake] ",
		"goTo": 2,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},2:{
		"text": " [shake rate=30 level=20]All the aliens, humans, just pixels on a screen?[/shake] ",
		"goTo": 3,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},3:{
		"text": " [shake rate=30 level=20]But he was DIFFERENT[/shake] ",
		"goTo": 4,
		"pitch":1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},4:{
		"text": " And now he's [color=red]DEAD[/color] ",
		"goTo": 5,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},5:{
		"text": " [shake rate=30 level=20]I know how pointless this is[/shake] ",
		"goTo": 6,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},6:{
		"text": " [shake rate=30 level=20]. . . . .[/shake] ",
		"goTo": 7,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},7:{
		"text": " But you'll [color=red]PAY[/color] ",
		"goTo": null,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},8:{
		"text": " What a moron ",
		"goTo": -1, # health regen
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},9:{
		"text": " ",
		"goTo": 10,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},10:{
		"text": " I've been around since version 1 ",
		"goTo": 11,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},11:{
		"text": "You think I haven't learned a thing or two?",
		"goTo": 12,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},12:{
		"text": "I've seen every strategy, every move you can make!",
		"goTo": 13,
		"pitch":1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},13:{
		"text": "You don't stand a chance",
		"goTo": 14,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},14:{
		"text": "For whatever it's worth...you're [color=red]never[/color] going to win.",
		"goTo": -2,
		"pitch": 1,
		"spriteName": 'IntelAngry',
		'choice': false 
	},15:{
		"text": ". . . . .",
		"goTo": 16,
		"pitch": 1,
		"spriteName": 'IntelNormal',
		'choice': false 
	},16:{
		"text": "Ah well",
		"goTo": -3,
		"pitch": 1,
		"spriteName": 'IntelSideEye',
		'choice': false 
	}
}
var currentPos = 0
var phase = 0
var closable = false

func _process(delta: float) -> void:
	$CanvasLayer/IntelHealth.value = intel.health

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && DialogManager.box.visible && phase < 1:
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				DialogManager.endCutscene()
				if phase==0:

					startPhase1()
			
			
			else:
				currentPos = next
				
				var item = dialog[currentPos]
				
				if item['choice']:
					DialogManager.showOptions(item['options'])
				else:
					DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
				
func _ready():
	
	intel.healthZero.connect(nextPhase)
	SceneService.fadeIn()
	LevelMusicManager.stopMusic()

func nextPhase():
	if phase == 1:
		phase = 2
		currentPos = 8
		var item = dialog[currentPos]
		DialogManager.startCutscene()
		DialogManager.cutsceneActive = true
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		currentPos = item['goTo']
		$DialogTimer.start(2)
	else:
		intel.health = 2000
		
func startPhase1():
	phase = 1
	LevelMusicManager.startMusic('boss_fight')
	intel.violent = true
	intelHealth.visible=true
	

func _on_talk_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		DialogManager.cutsceneActive = true
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		
		$TalkTrigger.queue_free()


func _on_fight_end_pressed() -> void:
	if closable:
		DataService.globalSettings['patched'] = true
		DataService.eraseAndReloadUserData()
		DataService.saveSettings()
		SceneService.changeSceneWithFade('MainMenu')


func _on_dialog_timer_timeout() -> void:
	if currentPos == -1:
		
		
		intel.health = 2000
		DialogManager.endCutscene()
		DialogManager.cutsceneActive = false
		
		currentPos = 9
		var item = dialog[currentPos]
		DialogManager.openBox()
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		currentPos = item['goTo']
		$DialogTimer.wait_time=3
	
	elif currentPos == -2:
		DialogManager.closeBox()
		$DevPatchTimer.start()
		$DialogTimer.stop()
		
	elif currentPos == -3:
		closable = true
		DialogManager.closeBox()
	else:
		var item = dialog[currentPos]
		DialogManager.openBox()
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
		currentPos = item['goTo']
				


func _on_dev_patch_timer_timeout() -> void:
	currentPos = 15
	LevelMusicManager.stopMusic()
	DialogManager.cutsceneActive = true
	$CanvasLayer/devPatch.visible = true
	var item = dialog[currentPos]
	DialogManager.openBox()
	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
	currentPos = item['goTo']
	$DialogTimer.start()
