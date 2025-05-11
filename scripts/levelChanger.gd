extends Area2D

@export var nextLevel = ''

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		DataService.saveUserData(int(nextLevel.lstrip('Level_')),body.health,body.ammoCount.get(1), body.ammoCount.get(2))
		SceneService.changeSceneWithFade(nextLevel)
