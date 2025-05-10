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
					queue_free()
			_:
				body.ammoCount[type]+= incValue
				queue_free()
		
