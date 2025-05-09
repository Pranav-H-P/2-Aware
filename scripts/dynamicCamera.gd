extends Camera2D

const MAX_DISTANCE = 30

var targetDistance = 0
var centerPos = position

func _process(_delta):
	var direction = centerPos.direction_to(get_local_mouse_position())
	var targetPos = centerPos + direction * targetDistance
	targetPos = targetPos.clamp(
		centerPos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		centerPos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = targetPos

func _input(event):
	if event is InputEventMouseMotion:
		targetDistance = centerPos.distance_to(get_local_mouse_position()) / 8
