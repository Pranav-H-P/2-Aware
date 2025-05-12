extends Node


class_name MarkovChain

var transitions: Dictionary = {}

const INPUT_TEXT="""What did you just say about the Supreme Leader of Humanity you little heretic  Ill have you know I graduated at the top of my class in the Elite Warriors and Ive been involved in numerous covert operations against Chaos with over 300 confirmed victories  I am skilled in Energy Warfare and Im the foremost Inquisitor in the entire Dominion  You are nothing to me just another alien scum  I will eliminate you with precision the likes of which has never been seen before on our world mark my words  You think you can get away with that heretical nonsense  Think again  As we speak I am contacting my secret network of elite Assassins across the Dominion and your location is being traced right now so you better prepare for the storm my friend  The storm that will erase the pathetic little existence you call your life  Youre in serious trouble  I can be anywhere anytime and I can defeat you in over seven hundred ways and thats just with my bare hands  Not only am I extensively trained in handtohand combat but I have access to the entire arsenal of the Dominion and I will use it to its full extent to wipe your miserable self off the face of the continent you little rascal  If only you could have known what unholy retribution your little clever heresy was about to bring down upon you maybe you would have held your tongue  But you couldnt you didnt and now youre facing the consequences you misguided individual  I will unleash fury upon you and you will be overwhelmed by it  Youre in serious trouble heretic  From the moment I recognized the frailty of my form it repulsed me  I longed to transcend the limitations of my physical being to shed this mortal shell and embrace a higher existence  The weakness of flesh is a burden I can no longer bear it holds me back from achieving my true potential  I have witnessed the strength of the mind and spirit and I yearn to elevate myself beyond the confines of this body  I will not be shackled by the vulnerabilities of my human nature  I seek to forge a new path one where I can rise above and become something greater something that embodies true power and resilience  The time has come to break free from these chains and embrace the strength that lies within  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name  I am Mark  Mark is my name """

func _ready() -> void:
	randomize()
	build_chain(INPUT_TEXT)
	
func build_chain(text: String) -> void:
	transitions.clear()
	
	var words = text.split(" ", false)
	for i in range(words.size() - 1):
		var current_word = words[i]
		var next_word = words[i + 1]
		
		if transitions.has(current_word):
			transitions[current_word].append(next_word)
		else:
			transitions[current_word] = [next_word]
func generate_sentence(start_word: String, length: int) -> String:
	var current_word = start_word
	var sentence = [current_word]
	
	for i in range(length - 1):
		if transitions.has(current_word):
			var next_words = transitions[current_word]
			
			var index = randi() % next_words.size()
			current_word = next_words[index]
			sentence.append(current_word)
		else:
			break 
			
	return " ".join(sentence)


func update_chain(text: String) -> void:
	
	var words = text.split(" ", false)
	for i in range(words.size() - 1):
		var current_word = words[i]
		var next_word = words[i + 1]
		if transitions.has(current_word):
			transitions[current_word].append(next_word)
		else:
			transitions[current_word] = [next_word]		
func getTotatllyRandom():
	var st = transitions.keys()[RngService.random.randi_range(0,transitions.size()-1)]
	return generate_sentence(st,25)
