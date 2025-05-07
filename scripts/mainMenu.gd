extends CanvasLayer


@onready var bgImg = $BackgroundImg
@onready var animations = $AnimationPlayer
@onready var flashCard = $FlashCard
@onready var flashCardTimer = $FlashCardTimer
@onready var flashCardText = $FlashCard/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel

const flashCardMessages = [
	"""[color=cyan][b]Congratulations![/b][/color]
	
	
	You've been selected for our exclusive closed beta!
	Your experiences and feedback will shape the future of the game.
	Feel free to contact us in case of any bugs/glitches""",
	"Live Reloading Enabled!"
]

var currentFlashcard = 0;

func _ready() -> void:
	bgImg.visible = false
	flashCard.visible = false
	showFlashCard(flashCardMessages[currentFlashcard])
	get_viewport().size = DisplayServer.screen_get_size()
	
	
func showFlashCard(cardData: String):
	flashCardText.text = cardData
	animations.play("flashcard_fade_in")
	

func hideFlashCard():
	animations.play("flashcard_fade_out")


func _on_flash_card_button_pressed() -> void:
	currentFlashcard += 1
	hideFlashCard()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'flashcard_fade_out' && currentFlashcard < flashCardMessages.size():
		showFlashCard(flashCardMessages[currentFlashcard])
	elif anim_name == 'flashcard_fade_out' && \
	currentFlashcard >= flashCardMessages.size() && \
	bgImg.visible == false:
		animations.play('bg_fade_in')
