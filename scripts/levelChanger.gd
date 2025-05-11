extends Area2D

@export var nextLevel = ''
@export var killCount = 0
@export var actionMessage = ''
@onready var level = get_parent()

var actionToDo = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if (killCount == 0 || level.killCount >= killCount) && !actionToDo:
			DataService.saveUserData(int(nextLevel.lstrip('Level_')),body.health,body.ammoCount.get(1), body.ammoCount.get(2))
			SceneService.changeSceneWithFade(nextLevel)
		else:
			if (actionToDo):
				DialogManager.openBox()
				DialogManager.showDialog(actionMessage,
				"IntelNormal",1.0)
				$Timer.start()
			else:
				DialogManager.openBox()
				DialogManager.showDialog('Clear this room before moving on. [color=red]'+str( killCount - level.killCount) + "[/color] Xenos left!",
				"IntelNormal",1.0)
				$Timer.start()


func _on_timer_timeout() -> void:
	DialogManager.closeBox()
