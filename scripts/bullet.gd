extends Area2D



var damage = 10
var speed = 4
var direction = Vector2.ZERO

@onready var despawnTimer = $Timer
@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D



var creator = "player"

func _physics_process(delta: float) -> void:
	
	global_position += direction * speed * delta * 100


func _on_timer_timeout() -> void:
	queue_free()

func hitAnim():
	sprite.visible=false
	particles.emitting = true
	despawnTimer.wait_time = particles.lifetime
	despawnTimer.start()

func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("pickup") || area.is_in_group("bullet"):
		return
	
	hitAnim()


func _on_body_entered(body: Node2D) -> void:
	
	print('from',creator,'hit',body.name)
	if body.is_in_group("player"):
		if creator != "player":
			body.health-=damage
			hitAnim()
		else:
			return
	elif body.is_in_group("enemy"):
		if creator != "enemy":
			body.health-=damage
			hitAnim()
		else:
			return
	
	
