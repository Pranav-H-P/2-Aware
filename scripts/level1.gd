extends Node2D


func _ready():
	SceneService.fadeIn()
	LevelMusicManager.startMusic('level_1')
