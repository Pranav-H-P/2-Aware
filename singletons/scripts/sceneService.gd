extends CanvasLayer

const scenePath = 'res://scenes/'
@onready var animations = $AnimationPlayer
@onready var colorRect = $ColorRect

func _ready() -> void:
	colorRect.visible = false

func sceneFadeOut():
	animations.play("fade_out")

func sceneFadeIn():
	animations.play_backwards("fade_out")

func changeScene(sceneName: String):
	sceneFadeOut()
	get_tree().change_scene_to_file(scenePath + sceneName + '.tscn')
