extends CharacterBody2D

signal healthZero()

const bullet = preload("res://nodes/bullet.tscn")

var attackTypeData={
	'ar':{
		"fireRate" : 300.0,
		"damage" : 5
	},'shotgun':{
		"fireRate" : 150.0,
		'spread':15,
		"damage" : 7
	},'sniper':{
		"fireRate" : 90.0,
		"damage" : 30
	},'circle':{
		"fireRate" : 100.0,
		'spread':15,
		"damage" : 6
	}
}


@onready var navAgent = $NavigationAgent2D
@onready var shootTimer = $ShootTimer
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var raycast = $Raycast
@onready var barrel = $barrel

@onready var player = get_parent().get_node('Player')

@export var shootRange = 1000
@export var maxApproachDist = 40
@export var detectionRadius = 10000
@export var health = 20000
@export var SPEED = 7
@export var bulletColor = Color("00f3ff")
@export var bulletSpeed = 2
@onready var shootsounds = [
	$"16Bitassaultrifleshot",
	$"16BitShotgunblast",
	$"16Bitsnipershot"
]

var attackType = 'ar'

var bulletAbove = false
var violent = false

func _ready() -> void:
	
	match DataService.getDifficulty():
		0:
			SPEED = 6
			bulletSpeed = 1
			attackTypeData['ar']['damage'] = 3
			attackTypeData['shotgun']['damage'] = 4
			attackTypeData['sniper']['damage'] = 13
			attackTypeData['circle']['damage'] = 3
		1:
			SPEED = 6
			bulletSpeed = 1
			
		2:
			pass
		3:
			SPEED = 8
			bulletSpeed = 3
			attackTypeData['ar']['damage'] = 10
			attackTypeData['shotgun']['damage'] = 9
			attackTypeData['sniper']['damage'] = 40
			attackTypeData['circle']['damage'] = 9
	
	
	makePath()
	shootTimer.one_shot = true
	shootTimer.wait_time =60.0 / attackTypeData[attackType]['fireRate']

func _physics_process(delta: float) -> void:
	raycast.target_position = (player.global_position - global_position).normalized()*shootRange
	raycast.global_position
	
	var distanceToPlayer = (player.global_position - global_position).length()
	
	if health <= 0:
		healthZero.emit()
		
	
	elif !DialogManager.cutsceneActive && violent:
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
				
				if body!=null && body.is_in_group("player") && shootTimer.is_stopped():
					shoot()
					shootTimer.start()
					
			
		velocity = lerp(get_real_velocity(),velocity,0.1)
	
	
	
func makePath():
	navAgent.target_position = player.global_position

func setAnimation(animName: String) ->void:
	if (animationPlayer.current_animation != animName):
		animationPlayer.play(animName)

func shoot():
	match attackType:
			
		'ar':
			var blt = bullet.instantiate()
			blt.creator = 'enemy'
			blt.modulate = bulletColor
			blt.speed = bulletSpeed * 2
			blt.damage = attackTypeData[attackType]['damage']
			blt.global_position = barrel.global_position
			var dir = (player.global_position - barrel.global_position).normalized()
			blt.direction = dir
			blt.z_index = 2 if bulletAbove else 0
			shootsounds[0].play()
			get_parent().add_child(blt)
		'shotgun':
			
		
			var dirCenter:Vector2 = (player.global_position - barrel.global_position).normalized()
		
			var dirs = [
				dirCenter,
				dirCenter.rotated(deg_to_rad(attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(3*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(-3*attackTypeData[attackType]['spread']))
				]
			for dir in dirs:
				var blt = bullet.instantiate()
				blt.modulate = bulletColor
				blt.creator = 'enemy'
				blt.damage = attackTypeData[attackType]['damage']
				blt.global_position = barrel.global_position
				blt.speed = bulletSpeed * 1.5
				blt.direction = dir
				blt.z_index = 2 if bulletAbove else 0
				
				get_parent().add_child(blt)
			shootsounds[1].play()
		'circle':
			
		
			var dirCenter:Vector2 = (player.global_position - barrel.global_position).normalized()
		
			var dirs = [
				dirCenter,
				dirCenter.rotated(deg_to_rad(attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(3*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(-3*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(2*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(-2*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(4*attackTypeData[attackType]['spread'])),
				dirCenter.rotated(deg_to_rad(-4*attackTypeData[attackType]['spread']))
				]
			for dir in dirs:
				var blt = bullet.instantiate()
				blt.modulate = bulletColor
				blt.creator = 'enemy'
				blt.damage = attackTypeData[attackType]['damage']
				blt.global_position = barrel.global_position
				blt.speed = bulletSpeed
				blt.direction = dir
				blt.z_index = 2 if bulletAbove else 0
				
				get_parent().add_child(blt)
			shootsounds[1].play()
			
		'sniper':
			var dir = (player.global_position - barrel.global_position).normalized()
		
			var blt = bullet.instantiate()
			blt.modulate = bulletColor
			blt.creator = 'enemy'
			blt.damage = attackTypeData[attackType]['damage']
			blt.global_position = barrel.global_position
			blt.speed = bulletSpeed * 3
			blt.direction = dir
			blt.z_index = 2 if bulletAbove else 0
			shootsounds[2].play()
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


func _on_attack_type_timer_timeout() -> void:
	var keyArr = attackTypeData.keys()
	attackType = keyArr[RngService.random.randi_range(0,keyArr.size()-1)]
	shootTimer.wait_time =60.0 / attackTypeData[attackType]['fireRate']
