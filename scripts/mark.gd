extends CharacterBody2D

signal killed()

@onready var animationPlayer = $AnimationPlayer
@onready var navAgent = $NavigationAgent2D
@onready var player = $"../Player"
@onready var navTimer = $NavTimer
@export var speed = 1
@export var damage = 5
var health = 2000
var violent = false
var punching = false



func _physics_process(delta: float) -> void:
	
	var distanceToPlayer = (player.global_position - global_position).length()
	
	if health <= 0:
		killed.emit()
		queue_free()
		set_physics_process(false)
		
	
	elif !DialogManager.cutsceneActive && violent:
		$CollisionShape2D.disabled = false
		process_mode = Node.PROCESS_MODE_PAUSABLE
		var playerDir = getPlayerDirection()
		
		
		if !punching:setAnimation("walk_"+playerDir)
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir*speed*delta*1000
		move_and_slide()
		
		
			
		velocity = lerp(get_real_velocity(),velocity,0.1)
		
		
	else:
		$CollisionShape2D.disabled = true
		if !DialogManager.cutsceneActive:
			if animationPlayer.current_animation != 'kneel':
				animationPlayer.play("kneel")
	
	
func makePath():
	navAgent.target_position = player.global_position

func setAnimation(animName: String) ->void:
	if (animationPlayer.current_animation != animName):
		animationPlayer.play(animName,-1,float(speed)/10.0)


func getPlayerDirection() -> String:
	
	var playerDir: Vector2 = player.global_position - global_position
	
	
	var vertical_position: String = ""
	if playerDir.y < 0:
		vertical_position = "up"
	else:
		vertical_position = "down"
	
	var horizontal_position: String = ""
	if playerDir.x < 0:
		horizontal_position = "left"
	else:
		horizontal_position = "right"
	
	
	var pos: String = 'down'
	
	if abs(playerDir.y) > abs(playerDir.x):
		pos = vertical_position
	else:
		pos = horizontal_position
	
	return pos


func _on_nav_timer_timeout() -> void:
	makePath()


func _on_upgrade_timer_timeout() -> void:
	damage += 5
	speed  += 4
	speed = clamp(speed, 0 ,10)
	LevelMusicManager.changePitch(LevelMusicManager.pitch_scale-0.1)


func _on_punch_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') && violent:
		$PunchNoise.play()
		animationPlayer.play("attack_"+getPlayerDirection())
		punching = true
		body.health-=damage
		$PunchTimer.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	punching = false
	if anim_name == 'teleport_out':
		DialogManager.endCutscene()
		DialogManager.cutsceneActive = false
		violent = true
		LevelMusicManager.changePitch(0.4)
		$UpgradeTimer.start()

func _on_punch_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		$PunchTimer.stop()
		punching = false

func _on_punch_timer_timeout() -> void:
	
	$PunchNoise.play()
	animationPlayer.play("attack_"+getPlayerDirection())
	punching = true
	player.health-=damage
