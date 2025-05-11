extends AudioStreamPlayer


const music = {
	'MainMenu': preload("res://assets/music/MainMenu.mp3"),
	'level_0':preload("res://assets/music/MilitaryMarch.mp3"),
	'level_1': preload("res://assets/music/Level 1.mp3"),
	'level_2': preload("res://assets/music/Level 2.mp3"),
	'level_3': preload("res://assets/music/Level 3.mp3"),
	'boss_fight': preload("res://assets/music/BossFightLooped.mp3"),
	'mark' : preload("res://assets/music/Mark.mp3")
}

var currentMusic = null

@onready var musicPlayer = $"/root/LevelMusicManager" as AudioStreamPlayer

func _process(delta: float) -> void:
	if DialogManager.cutsceneActive:
		musicPlayer.volume_db = -5
	else:
		musicPlayer.volume_db = 0


func startMusic(levelName):
	if levelName != currentMusic:
		currentMusic = levelName
		musicPlayer.pitch_scale = 1
		musicPlayer.stream = music[levelName]
		musicPlayer.play()
		
func changePitch(changeTo):
	musicPlayer.pitch_scale = changeTo
func stopMusic():
	musicPlayer.stop()
	currentMusic = null
