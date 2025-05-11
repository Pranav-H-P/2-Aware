extends CanvasLayer

const glitchTexture = preload("res://animations/GlitchEffect.tres")

func _ready() -> void:
	$TextureRect.visible = false

func startGlitch():
	$TextureRect.texture = glitchTexture
	$TextureRect.visible = true
func stopGlitch():
	$TextureRect.texture = null
	$TextureRect.visible = false
