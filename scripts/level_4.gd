extends Node2D




var killCount = 0

func _ready() -> void:
	
	SceneService.fadeIn()
	LevelMusicManager.startMusic('level_1')
	
