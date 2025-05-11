extends Area2D

enum TYPES{
	HEALTH=0,
	SHOTGUN=1,
	SNIPER=2
}

const sprites = [ 
	preload("res://assets/sprites/Medkit.png"),
	preload("res://assets/sprites/ShotgunAmmo.png"),
	preload("res://assets/sprites/SniperAmmo.png")
	]

@onready var sprite = $Sprite2D
@onready var soundEffects = [$HealthPickup, $ShotgunPickup, $SniperPickup]

@export var incValue = 10

@export var type:TYPES = TYPES.HEALTH;

func setTypeData(typeInt: int, incVal = null):
	type = typeInt
	
	sprite.texture = sprites[type]
	
	if incVal!= null:
		incValue = incVal

func _ready() -> void:
	setTypeData(type)

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group('player'):
		match type:
			TYPES.HEALTH:
				
				if body.health < 100:
					
					body.health = clamp(incValue + body.health, 0, 100)
					soundEffects[type].play()
					visible=false
					incValue = 0
					$CollisionShape2D.disabled = true
			_:
				body.ammoCount[type]+= incValue
				soundEffects[type].play()
				visible=false
				incValue = 0
				$CollisionShape2D.disabled = true
		


func _on_pickup_finished() -> void:
	queue_free()
