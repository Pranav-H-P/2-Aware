extends Node2D

var markAlive = true
@onready var mark = $Mark


func _ready() -> void:
	mark.killed.connect(markKilled)

func _on_mark_talk_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func markKilled():
	markAlive = false
	$GlitchEffect.startGlitch()
	$GlitchTimer.start()


func _on_glitch_timer_timeout() -> void:
	$GlitchEffect.stopGlitch()
