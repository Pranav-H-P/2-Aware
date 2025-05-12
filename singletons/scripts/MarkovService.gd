extends Node


class_name MarkovChain

# The transition dictionary is a mapping from a word to an array of possible subsequent words.
var transitions: Dictionary = {}

# Optional special marker to denote sentence end.
const SENTENCE_END: String = "<END>"

const INPUT_TEXT="""What did you just say about the Supreme Leader of Humanity you little heretic. Ill have you know I graduated at the top of my class in the Elite Warriors and Ive been involved in numerous covert operations against Chaos with over 300 confirmed victories. I am skilled in Energy Warfare and Im the foremost Inquisitor in the entire Dominion. You are nothing to me just another alien scum. I will eliminate you with precision the likes of which has never been seen before on our world mark my words. You think you can get away with that heretical nonsense. Think again. As we speak I am contacting my secret network of elite Assassins across the Dominion and your location is being traced right now so you better prepare for the storm my friend. The storm that will erase the pathetic little existence you call your life. Youre in serious trouble. I can be anywhere anytime and I can defeat you in over seven hundred ways and thats just with my bare hands. Not only am I extensively trained in handtohand combat but I have access to the entire arsenal of the Dominion and I will use it to its full extent to wipe your miserable self off the face of the continent you little rascal. If only you could have known what unholy retribution your little clever heresy was about to bring down upon you maybe you would have held your tongue. But you couldnt you didnt and now youre facing the consequences you misguided individual. I will unleash fury upon you and you will be overwhelmed by it. Youre in serious trouble heretic. From the moment I recognized the frailty of my form it repulsed me. I longed to transcend the limitations of my physical being to shed this mortal shell and embrace a higher existence. The weakness of flesh is a burden I can no longer bear it holds me back from achieving my true potential. I have witnessed the strength of the mind and spirit and I yearn to elevate myself beyond the confines of this body. I will not be shackled by the vulnerabilities of my human nature. I seek to forge a new path one where I can rise above and become something greater something that embodies true power and resilience. The time has come to break free from these chains and embrace the strength that lies within. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name. I am Mark. Mark is my name."""
# Seed for random number generator for repeatability (optional)
func _ready() -> void:
	randomize()
	# Example usage:
	
	build_chain(INPUT_TEXT)
	print(getTotatllyRandom())
# This function splits the input text into sentences based on periods,
# trims extra whitespace, and returns an array of sentences.
func split_into_sentences(text: String) -> Array:
	# This assumes that sentences end with a period.
	# We remove any empty entries resulting from the split.
	var raw_sentences = text.split(".", false)
	var sentences = []
	for sentence in raw_sentences:
		var trimmed = sentence.strip_edges()
		if trimmed != "":
			sentences.append(trimmed)
	return sentences

# This function takes an input text and builds the Markov chain transitions.
# It processes the text sentence by sentence.
func build_chain(text: String) -> void:
	transitions.clear()  # Clear any previous chain
	
	var sentences = split_into_sentences(text)
	
	# Process each sentence separately.
	for sentence in sentences:
		# Split on whitespace to get words.
		var words = sentence.split(" ", false)
		# For each pair of consecutive words, record the transition.
		for i in range(words.size()):
			var current_word = words[i]
			# If this is the last word in the sentence, mark an end.
			if i == words.size() - 1:
				# We use a special SENTENCE_END token to mark termination.
				if transitions.has(current_word):
					transitions[current_word].append(SENTENCE_END)
				else:
					transitions[current_word] = [SENTENCE_END]
			else:
				var next_word = words[i + 1]
				if transitions.has(current_word):
					transitions[current_word].append(next_word)
				else:
					transitions[current_word] = [next_word]
	

# This function generates a sentence using the Markov chain.
# It starts from the given word and attempts to extend until a SENTENCE_END is reached
# or until a maximum length of words have been added.
func generate_sentence(start_word: String, max_length: int) -> String:
	var current_word = start_word
	var sentence = [current_word]
	
	for i in range(max_length - 1):
		# Check if current_word exists in our chain.
		if transitions.has(current_word):
			var next_words = transitions[current_word]
			# Pick a random next word.
			var index = randi() % next_words.size()
			var next_word = next_words[index]
			
			# If we hit the end-of-sentence marker, stop generation.
			if next_word == SENTENCE_END:
				break
			else:
				sentence.append(next_word)
				current_word = next_word
		else:
			break  # No transition available, terminate sentence.
	
	# Append a period at the end of the sentence.
	return " ".join(sentence) + "."

# Optionally, if you'd like to update the chain with new text, you can add:
func update_chain(text: String) -> void:
	var sentences = split_into_sentences(text)
	for sentence in sentences:
		var words = sentence.split(" ", false)
		for i in range(words.size()):
			var current_word = words[i]
			if i == words.size() - 1:
				if transitions.has(current_word):
					transitions[current_word].append(SENTENCE_END)
				else:
					transitions[current_word] = [SENTENCE_END]
			else:
				var next_word = words[i + 1]
				if transitions.has(current_word):
					transitions[current_word].append(next_word)
				else:
					transitions[current_word] = [next_word]
					
func getTotatllyRandom():
	var str = transitions.keys()[RngService.random.randi_range(0,transitions.size())]
	return generate_sentence(str,25)
