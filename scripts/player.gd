extends CharacterBody2D

enum WEAPON{
	AR = 0,
	SHOTGUN = 1,
	SNIPER = 2
}
const crosshairAR =  preload("res://assets/sprites/crosshairAR.png")
const crosshairShotgun =  preload("res://assets/sprites/crosshairShotgun.png")
const crosshairSniper = preload("res://assets/sprites/crosshairSniper.png")
const bullet = preload("res://nodes/bullet.tscn")


@onready var barrel = $barrel


const WEAPON_STATS : Dictionary =  { 
	WEAPON.AR: {
		"crosshair" : crosshairAR,
		"fireRate" : 480.0,
		"damage" : 10
	} ,
  	WEAPON.SHOTGUN:{
		"crosshair" : crosshairShotgun,
		"fireRate" : 60.0,
		'spread':15,
		"damage" : 22
	},
	WEAPON.SNIPER:{
		"crosshair" : crosshairSniper,
		"fireRate" : 45.0,
		"damage" : 100
	}
 }

@onready var animationPlayer = $AnimationPlayer
@onready var shootTimer = $ShootTimer
@onready var ui = get_parent().get_node('UI')
@onready var deathNoise = $"8BitplayerDeathNoise"

@export var SPEED = 10
@export var bulletColor = Color("ffd702")

var bulletAbove = true; # sets bullet to above player in z index
var currentWeapon = WEAPON.AR
var ammoCount =  {
	WEAPON.SHOTGUN :  0, 
	WEAPON.SNIPER : 0
}# AR has unlimited Ammo


var health = 100

var actionsValid = false
var actionDone = false

func _ready() -> void:
	shootTimer.one_shot = true
	ammoCount[WEAPON.SHOTGUN] = DataService.getAmmoData()[0]
	ammoCount[WEAPON.SNIPER] = DataService.getAmmoData()[1]
	setWeapon(currentWeapon)

func addAmmo(type: WEAPON, count : int):
	ammoCount[type] = ammoCount[type] + count

func resetAmmo():
	ammoCount[WEAPON.SHOTGUN] = 0
	ammoCount[WEAPON.SNIPER] = 0

func setWeapon(type : WEAPON):
	currentWeapon = type
	shootTimer.wait_time = 60.0 / WEAPON_STATS[currentWeapon]['fireRate']
	
	Input.set_custom_mouse_cursor(WEAPON_STATS[currentWeapon]['crosshair'])

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
	
	bulletAbove = true
	if pos == "up": bulletAbove = false
	return pos


func setAnimation(animName: String) ->void:
	if (animationPlayer.current_animation != animName):
		animationPlayer.play(animName)
		
func cycleWeapon(direction):
	if direction == 1:
		currentWeapon = (currentWeapon + 1) % WEAPON.size()
	else :
		currentWeapon = ((currentWeapon - 1 + 3)) % WEAPON.size()
	setWeapon(currentWeapon)
	
func _physics_process(delta: float) -> void:
	
	if health <= 0:
		deathNoise.play()
		animationPlayer.play("death")
		set_physics_process(false)
		
	elif !DialogManager.cutsceneActive:
		var mouseDir = getMouseDirection()
		velocity.x = Input.get_axis("left","right") * SPEED * delta * 1000
		velocity.y = Input.get_axis("up","down") * SPEED * delta * 1000
		if (velocity.x == 0 && velocity.y == 0):
			setAnimation("idle_"+mouseDir)
		else:
			setAnimation("walk_"+mouseDir)
		if velocity.length() > 1: velocity.normalized() 
		velocity = lerp(get_real_velocity(),velocity,0.1)
		
		
		if (Input.is_action_pressed("shoot")):
			if (shootTimer.is_stopped()):
				shoot(WEAPON_STATS[currentWeapon])
				shootTimer.start()
				
		if actionsValid:
			if Input.is_action_pressed('interact'):
				actionDone = true
				animationPlayer.play("action_"+mouseDir)
		
		move_and_slide()
		
		if Input.is_action_pressed('1'):
			setWeapon(WEAPON.AR)
		elif Input.is_action_pressed('2'):
			setWeapon(WEAPON.SHOTGUN)
		elif Input.is_action_pressed('3'):
			setWeapon(WEAPON.SNIPER)
		if Input.is_action_just_released("mouse_wheel_down"):
			cycleWeapon(-1)
		elif Input.is_action_just_released("mouse_wheel_up"):
			cycleWeapon(1)
	
	ui.updatePlayerStats({
		'health': health,
		'ammo': [int(ammoCount[WEAPON.SHOTGUN]) , int(ammoCount[WEAPON.SNIPER])],
		'ammoSelect': int(currentWeapon)
	})
	
	
	

func shoot(bulletData):
	if (currentWeapon == WEAPON.AR):
		var blt = bullet.instantiate()
		blt.creator = 'player'
		blt.modulate = bulletColor
		blt.damage = WEAPON_STATS[currentWeapon]['damage']
		blt.global_position = barrel.global_position
		var dir = (get_global_mouse_position() - barrel.global_position).normalized()
		blt.direction = dir
		blt.z_index = 2 if bulletAbove else 0
		get_parent().add_child(blt)
	else:
		if ammoCount[currentWeapon] > 0:
			
			if currentWeapon== WEAPON.SHOTGUN:
				
			
				var dirCenter:Vector2 = (get_global_mouse_position() - barrel.global_position).normalized()
			
				var dirs = [
					dirCenter,
					dirCenter.rotated(deg_to_rad(WEAPON_STATS[currentWeapon]['spread'])),
					dirCenter.rotated(deg_to_rad(-WEAPON_STATS[currentWeapon]['spread'])),
					dirCenter.rotated(deg_to_rad(2*WEAPON_STATS[currentWeapon]['spread'])),
					dirCenter.rotated(deg_to_rad(-2*WEAPON_STATS[currentWeapon]['spread'])),
					dirCenter.rotated(deg_to_rad(3*WEAPON_STATS[currentWeapon]['spread'])),
					dirCenter.rotated(deg_to_rad(-3*WEAPON_STATS[currentWeapon]['spread']))
					]
				for dir in dirs:
					var blt = bullet.instantiate()
					blt.modulate = bulletColor
					blt.creator = 'player'
					blt.damage = WEAPON_STATS[currentWeapon]['damage']
					blt.global_position = barrel.global_position
					blt.speed = blt.speed
					blt.direction = dir
					blt.z_index = 2 if bulletAbove else 0
					get_parent().add_child(blt)

			else: # sniper
				var dir = (get_global_mouse_position() - barrel.global_position).normalized()
			
				var blt = bullet.instantiate()
				blt.modulate = bulletColor
				blt.creator = 'player'
				blt.damage = WEAPON_STATS[currentWeapon]['damage']
				blt.global_position = barrel.global_position
				blt.speed = blt.speed*2
				blt.direction = dir
				blt.z_index = 2 if bulletAbove else 0
				get_parent().add_child(blt)
			ammoCount[currentWeapon] -= 1
		else:
			print('empty noise')

	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'death':
		ui.showDeathScreen()	
