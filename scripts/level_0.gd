extends Node2D

const dialog = {
	0:{
		"text":'',
		"goTo": 0,
	}
}

func _ready():
	SceneService.fadeIn()
	LevelMusicManager.stopMusic()
