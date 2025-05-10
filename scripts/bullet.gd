extends Area2D

var damage = 10
var speed = 5
var direction = Vector2.ZERO

@onready var despawnTimer = $Timer

func _physics_process(delta: float) -> void:
	
	global_position += direction * speed * delta * 100


func _on_timer_timeout() -> void:
	queue_free()
