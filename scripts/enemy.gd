extends CharacterBody2D


const arAlienSprite = preload("res://assets/sprites/spritesheetAlien.png")
const shotgunAlienSprite = preload("res://assets/sprites/spritesheetAlienRed.png")
const sniperAlienSprite = preload("res://assets/sprites/spritesheetAlienYellow.png")
const bullet = preload("res://nodes/bullet.tscn")
const pickup =preload("res://nodes/Pickup.tscn")

enum ALIEN_TYPE{
	NORMAL = 0,
	SHOTGUN = 1,
	SNIPER = 2
}

const ALIEN_DATA:Dictionary = {
	ALIEN_TYPE.NORMAL: {
		'sprite':arAlienSprite,
		"fireRate" : 480.0,
		"damage" : 5
	},
	ALIEN_TYPE.SHOTGUN: {
		'sprite':shotgunAlienSprite,
		"fireRate" : 60.0,
		'spread':15,
		"damage" : 7
	},
	ALIEN_TYPE.SNIPER: {
		'sprite':sniperAlienSprite,
		"fireRate" : 45.0,
		"damage" : 30
	}
}

@onready var navAgent = $NavigationAgent2D
@onready var shootTimer = $ShootTimer
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var raycast = $Raycast
@onready var barrel = $barrel

@onready var player = get_parent().get_node('Player')

@export var shootRange = 500
@export var maxApproachDist = 100
@export var detectionRadius = 700
@export var health = 100
@export var alienType: ALIEN_TYPE = ALIEN_TYPE.NORMAL
@export var SPEED = 5
@export var bulletColor = Color("26ff00")
@export var bulletSpeed = 2
@onready var shootsounds = [
	$"16Bitassaultrifleshot",
	$"16BitShotgunblast",
	$"16Bitsnipershot"
]

var bulletAbove = false


func _ready() -> void:
	makePath()
	shootTimer.one_shot = true
	sprite.texture = ALIEN_DATA[alienType]['sprite']
	if alienType == ALIEN_TYPE.SHOTGUN:
		maxApproachDist = 40
	shootTimer.wait_time =60.0 / ALIEN_DATA[alienType]['fireRate']

func _physics_process(delta: float) -> void:
	raycast.target_position = (player.global_position - global_position).normalized()*shootRange
	raycast.global_position
	
	var distanceToPlayer = (player.global_position - global_position).length()
	
	if health <= 0:
		$DeathNoise.play()
		animationPlayer.play("death")
		set_physics_process(false)
		
	
	elif !DialogManager.cutsceneActive:
		var playerDir = getPlayerDirection()
		
		if distanceToPlayer > maxApproachDist && distanceToPlayer < detectionRadius:
			setAnimation("walk_"+playerDir)
			var dir = to_local(navAgent.get_next_path_position()).normalized()
			velocity = dir*SPEED*delta*1000
			
			move_and_slide()
			
		else:
			setAnimation("idle_"+playerDir)
		
		if distanceToPlayer < detectionRadius:
			if raycast.is_colliding():
				var body = raycast.get_collider()
				
				if body.is_in_group("player") && shootTimer.is_stopped():
					shoot()
					shootTimer.start()
					
			
		velocity = lerp(get_real_velocity(),velocity,0.1)
	
	
	
func makePath():
	navAgent.target_position = player.global_position

func setAnimation(animName: String) ->void:
	if (animationPlayer.current_animation != animName):
		animationPlayer.play(animName)

func shoot():
	match alienType:
			
		ALIEN_TYPE.NORMAL:
			var blt = bullet.instantiate()
			blt.creator = 'enemy'
			blt.modulate = bulletColor
			blt.speed = bulletSpeed
			blt.damage = ALIEN_DATA[alienType]['damage']
			blt.global_position = barrel.global_position
			var dir = (player.global_position - barrel.global_position).normalized()
			blt.direction = dir
			blt.z_index = 2 if bulletAbove else 0
			shootsounds[alienType].play()
			get_parent().add_child(blt)
		ALIEN_TYPE.SHOTGUN:
			
		
			var dirCenter:Vector2 = (player.global_position - barrel.global_position).normalized()
		
			var dirs = [
				dirCenter,
				dirCenter.rotated(deg_to_rad(ALIEN_DATA[alienType]['spread'])),
				dirCenter.rotated(deg_to_rad(3*ALIEN_DATA[alienType]['spread'])),
				dirCenter.rotated(deg_to_rad(-3*ALIEN_DATA[alienType]['spread']))
				]
			for dir in dirs:
				var blt = bullet.instantiate()
				blt.modulate = bulletColor
				blt.creator = 'enemy'
				blt.damage = ALIEN_DATA[alienType]['damage']
				blt.global_position = barrel.global_position
				blt.speed = bulletSpeed
				blt.direction = dir
				blt.z_index = 2 if bulletAbove else 0
				
				get_parent().add_child(blt)
			shootsounds[alienType].play()
			
		ALIEN_TYPE.SNIPER:
			var dir = (player.global_position - barrel.global_position).normalized()
		
			var blt = bullet.instantiate()
			blt.modulate = bulletColor
			blt.creator = 'enemy'
			blt.damage = ALIEN_DATA[alienType]['damage']
			blt.global_position = barrel.global_position
			blt.speed = bulletSpeed*2
			blt.direction = dir
			blt.z_index = 2 if bulletAbove else 0
			shootsounds[alienType].play()
			get_parent().add_child(blt)


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
	
	bulletAbove = true
	if pos == "up": bulletAbove = false
	return pos


func _on_nav_timer_timeout() -> void:
	makePath()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if RngService.random.randi()%2 == 0:
		var pick = pickup.instantiate()
		pick.global_position = global_position
		get_parent().add_child(pick)
		
		pick.setTypeData(alienType, RngService.random.randi_range(1,3))
		
		
		
		
		
	queue_free()
