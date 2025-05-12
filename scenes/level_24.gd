extends Node2D




var dialog = {}

var currentPos = 0
var markAlive = true
@onready var mark = $Mark
	
func generateMarkDialog():
	var startSentence = MarkovService.getTotatllyRandom()
	
	dialog[0]={
		"text": startSentence,
		"goTo": 1,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	dialog[1]={
		"text": MarkovService.generate_sentence(getLastWord(startSentence),25),
		"goTo": 2,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	
	
	for i in range(2,8):
		dialog[i] = {
		"text": MarkovService.generate_sentence(getLastWord(dialog[i-1]['text']),25),
		"goTo": i+1,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	
	dialog[8] =	{
		'choice': true,
		'options':[
					{
						'text':"Sir, hold tight I'm here to free you",
						'goTo': 9
					},
					{
						'text':"Don't worry, Intel sent me",
						'goTo':10
					},
				]
	
			}
	dialog[9]={
		"text": MarkovService.generate_sentence("you",25),
		"goTo": 11,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	dialog[10]={
		"text": MarkovService.generate_sentence("me",25),
		"goTo": 11,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	
	for i in range(11,15):
		dialog[i] = {
		"text": MarkovService.generate_sentence(getLastWord(dialog[i-1]['text']),25),
		"goTo": i+1,
		"pitch": 0.5,
		"spriteName": 'Mark',
		'choice': false 
	}
	dialog[15] =	{
		'choice': true,
		'options':[
					{
						'text':"I'm freeing you, come with me",
						'goTo': null
					},
					{
						'text':"I'll take those restraints off",
						'goTo':null
					},
				]
	
			}
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && DialogManager.box.visible:
		if !dialog[currentPos]['choice']:
			var next = dialog[currentPos]['goTo']
			if next == null:
				$GlitchEffect.startGlitch()
				$GlitchTimer.start()
				mark.violent = true
				mark.animationPlayer.play('kneel_teleport')
				$MarkTalk.queue_free()
			else:
				currentPos = next
				
				var item = dialog[currentPos]
				
				if item['choice']:
					DialogManager.showOptions(item['options'])
				else:
					DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])
				

func _ready() -> void:
	SceneService.fadeIn()
	LevelMusicManager.startMusic('mark')
	
	generateMarkDialog()
	
	DialogManager.OptionSelected.connect(choiceOver)
	mark.killed.connect(markKilled)

func getLastWord(st:String):
	var arr = st.split(' ')
	return arr[-1]
func choiceOver(choice):
	var next = choice['goTo']
	LevelMusicManager.changePitch(0.7)
	if next == null:
		$GlitchEffect.startGlitch()
		$GlitchTimer.start()
		mark.violent = true
		$Fog/FogAnim.play('fade_in')
		mark.animationPlayer.play('kneel_teleport')
		if $MarkTalk != null:
			$MarkTalk.queue_free()
		return
	currentPos = next
	
	var item = dialog[currentPos]

	DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


func _on_mark_talk_body_entered(body: Node2D) -> void:
	if (body.is_in_group('player')):
		DialogManager.cutsceneActive = true
		DialogManager.startCutscene()
		currentPos = 0
		var item = dialog[currentPos]
		DialogManager.showDialog(item['text'],item['spriteName'],item['pitch'])


func markKilled():
	markAlive = false
	$GlitchEffect.startGlitch()
	$GlitchTimer.start()


func _on_glitch_timer_timeout() -> void:
	$GlitchEffect.stopGlitch()
	if !markAlive:
		$ObjectiveMarker.global_position = $LevelChanger.global_position
		$pathBlocker.queue_free()
		$Fog/FogAnim.play_backwards('fade_in')
	else:
		mark.animationPlayer.play_backwards('teleport_out')
		# mark will set cutscene off
