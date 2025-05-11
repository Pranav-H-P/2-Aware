extends Node2D

"""
func _ready() -> void:
	SceneService.fadeIn()
	LevelMusicManager.startMusic('level_0')
"""

func _ready():
	SceneService.fadeIn()
	LevelMusicManager.stopMusic()
