extends Node2D



@onready var CompassNeedle = $CanvasLayer/Control/MarginContainer2/Control/CompassNeedle
@onready var player = $"../Player"


func _process(delta: float) -> void:
	var dir = -(player.global_position - global_position).normalized() as Vector2
	
	CompassNeedle.rotation = dir.rotated(deg_to_rad(90)).angle()
	
	
	
