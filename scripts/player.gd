extends CharacterBody2D


@onready var animationPlayer = $AnimationPlayer
@onready var timeoutTimer = $TimeoutTimer
@onready var shootTimer = $ShootTimer

@export var FIRE_RATE = 0.1
@export var SPEED = 10

var controllable = true; # for cutscenes

func _ready() -> void:
	shootTimer.wait_time = FIRE_RATE;
	shootTimer.one_shot = true

func getMouseDirection() -> String:
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	
	var vDiff = mouse_pos.y - screen_size.y * 0.5;
	var hDiff = mouse_pos.x - screen_size.x * 0.5;
	var vertical_position: String = ""
	if mouse_pos.y < screen_size.y * 0.5:
		vertical_position = "up"
	else:
		vertical_position = "down"
	
	var horizontal_position: String = ""
	if mouse_pos.x < screen_size.x * 0.5:
		horizontal_position = "left"
	else:
		horizontal_position = "right"
		
	var pos: String = 'down'
	if abs(vDiff) > abs(hDiff):
		pos = vertical_position
	else:
		pos = horizontal_position
	return pos

func setAnimation(name: String) ->void:
	if (animationPlayer.current_animation != name):
		animationPlayer.play(name)
		
	

func _physics_process(delta: float) -> void:
	var mouseDir = getMouseDirection()
	velocity.x = Input.get_axis("left","right") * SPEED
	velocity.y = Input.get_axis("up","down") * SPEED
	if (velocity.x == 0 && velocity.y == 0):
		setAnimation("idle_"+mouseDir)
	else:
		setAnimation("walk_"+mouseDir)
	
	velocity = lerp(get_real_velocity(),velocity,0.1)
	
	
	if (Input.is_action_pressed("shoot")):
		if (shootTimer.is_stopped()):
			shootTimer.start()
	
	move_and_slide()
	
	
	


func _on_shoot_timer_timeout() -> void:
	print("shooting")
