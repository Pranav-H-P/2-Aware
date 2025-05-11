extends Area2D

enum DIR{
	UP,
	DOWN
}

enum COLOR{
	RED,
	GREEN,
	YELLOW,
	PURPLE,
	BLUE
}

const gameSprite = {
	COLOR.RED: preload("res://assets/sprites/spritesheetRedSoldier.png"),
	COLOR.GREEN: preload("res://assets/sprites/spritesheetGreenSoldier.png"),
	COLOR.YELLOW: preload("res://assets/sprites/spritesheetYellowSoldier.png"),
	COLOR.PURPLE: preload("res://assets/sprites/spritesheetPurpleSoldier.png"),
	COLOR.BLUE: preload("res://assets/sprites/spritesheetBlueSoldier.png")
}

const dialogSpriteName = {
	COLOR.RED: "SoldierRed",
	COLOR.GREEN: "SoldierGreen",
	COLOR.YELLOW: "SoldierYellow",
	COLOR.PURPLE: "SoldierPurple",
	COLOR.BLUE: "SoldierBlue"
}

@export var dialog = ""
@export var color: COLOR;
@export var direction: DIR = DIR.DOWN;

var cutSceneStarted = false

func _ready():
	
	if direction == DIR.UP:
		$AnimationPlayer.play("default_up")
	else:
		$AnimationPlayer.play("default_down")
	$Sprite2D.texture = gameSprite[color]
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if cutSceneStarted:
			$AnimationPlayer.play('disappear')
			
			
func talk():
	
	DialogManager.startCutscene()
	DialogManager.showDialog(dialog,dialogSpriteName[color],0.7)
	cutSceneStarted = true
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'disappear':
		DialogManager.endCutscene()
		queue_free()
