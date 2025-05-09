extends Area2D

var damage = 10
var speed = 5
var direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	
	global_position += direction * speed * delta * 100
