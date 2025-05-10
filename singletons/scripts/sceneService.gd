extends CanvasLayer

const scenePath = 'res://scenes/'
@onready var animations = $AnimationPlayer
@onready var colorRect = $ColorRect

var changeTo = '';

func _ready() -> void:
	colorRect.visible = false

func fadeOut():
	animations.play("fade_out")

func fadeIn():
	animations.play_backwards("fade_out")
	
func changeSceneWithFade(sceneName: String):
	animations.play("fade_out_change_on_end")
	changeTo = sceneName

func reloadWithFade():
	animations.play("fade_out_restart_on_end")

func changeScene(sceneName: String):
	get_tree().change_scene_to_file(scenePath + sceneName + '.tscn')


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fade_out_change_on_end':
		changeScene(changeTo)
	elif anim_name == 'fade_out_restart_on_end':
		get_tree().reload_current_scene()
