extends Node

var rng = RandomNumberGenerator.new()

func is_vowel(in_letter):
	return in_letter == "a" or in_letter == "e" or in_letter == "i" or in_letter == "o" or in_letter == "u" or in_letter == "y"

var probs = {}

var start_probs = {"a": 1, "b": 2, "c": 2, "d":2, "e": 0.5, "f": 0.8, "g": 2,
		"h": 1.5, "i": 0.3, "j": 0.5, "k": 1, "l": 2, "m": 2, "n": 2,
		"o": 1, "p": 2, "q": 0.1, "r": 2, "s": 2, "t": 2, "u": 0.4, 
		"v": 0.1, "w": 0.9, "x": 0, "y": 0.3, "z": 0.04}

func _ready():
	#rng.seed = 10
	probs["a"] = {"a": 0.001, "b": 2, "c": 2, "d":2, "e": 0.01, "f": 2, "g": 2,
			"h": 0.2, "i": 1, "j": 0.05, "k": 0.7, "l": 2, "m": 2, "n": 2, 
			"o": 0.2, "p": 1, "q": 0, "r": 2, "s": 1.5, "t": 2, "u": 0.8, 
			"v": 0.1, "w": 0.5, "x": 0.1, "y": 0.1, "z": 0.08}

	probs["b"] = {"a": 1, "b": 0.1, "c": 0, "d": 0.1, "e": 1, "f": 0, "g": 0,
			"h": 0, "i": 1, "j": 0.05, "k": 0, "l": 1, "m": 0.05, "n": 0.08, 
			"o": 1, "p": 0, "q": 0, "r": 0.8, "s": 0.8, "t": 0, "u": 0.8, 
			"v": 0.06, "w": 0.04, "x": 0, "y": 0.1, "z": 0.08}

	probs["c"] = {"a": 1, "b": 0, "c": 0.05, "d": 0, "e": 0.2, "f": 0, "g": 0,
			"h": 0.5, "i": 1, "j": 0, "k": 1, "l": 0.1, "m": 0.05, "n": 0.02, 
			"o": 1, "p": 0, "q": 0, "r": 0.1, "s": 0.3, "t": 0.3, "u": 0.8, 
			"v": 0, "w": 0, "x": 0, "y": 0.04, "z": 0}

	probs["d"] = {"a": 1, "b": 0, "c": 0, "d": 0.1, "e": 1, "f": 0, "g": 0.2,
			"h": 0.02, "i": 1, "j": 0.05, "k": 0, "l": 0.8, "m": 0.05, "n": 0.08, 
			"o": 1, "p": 0, "q": 0, "r": 0.8, "s": 0.8, "t": 0, "u": 0.8, 
			"v": 0.05, "w": 0.08, "x": 0, "y": 0.1, "z": 0.08}

	probs["e"] = {"a": 0.5, "b": 1, "c": 0.8, "d": 1, "e": 0.4, "f": 0.8, "g": 0.6, 
			"h": 0.02, "i": 0.05, "j": 0, "k": 0.07, "l": 0.8, "m": 1, "n": 1, 
			"o": 0.2, "p": 0.8, "q": 0, "r": 1, "s": 0.8, "t": 1, "u": 0.08, 
			"v": 0.2, "w": 0, "x": 0.1, "y": 0.1, "z": 0.08}

	probs["f"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0.3, "g": 0, 
			"h": 0, "i": 1, "j": 0, "k": 0, "l": 1, "m": 0.05, "n": 0.08, 
			"o": 1, "p": 0, "q": 0, "r": 1, "s": 0.3, "t": 1, "u": 0.8, 
			"v": 0, "w": 0, "x": 0, "y": 0.1, "z": 0}

	probs["g"] = {"a": 1, "b": 0.05, "c": 0, "d": 0.05, "e": 1, "f": 0, "g": 0.1, 
			"h": 0.02, "i": 0.7, "j": 0, "k": 0, "l": 0.5, "m": 0.3, "n": 0.3, 
			"o": 1, "p": 0, "q": 0, "r": 1, "s": 1, "t": 0, "u": 0.8, 
			"v": 0, "w": 0.04, "x": 0, "y": 0.1, "z": 0.08}

	probs["h"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0.03, "g": 0, 
			"h": 0, "i": 1, "j": 0, "k": 0, "l": 0, "m": 0.05, "n": 0.08, 
			"o": 1, "p": 0, "q": 0, "r": 0, "s": 0.3, "t": 0, "u": 0.8, 
			"v": 0, "w": 0, "x": 0, "y": 0.1, "z": 0}

	probs["i"] = {"a": 0.5, "b": 1, "c": 0.3, "d": 1, "e": 0.2, "f": 0.7, "g": 0.6, 
			"h": 0, "i": 0, "j": 0, "k": 0.07, "l": 0.6, "m": 1, "n": 1, 
			"o": 0.2, "p": 0.8, "q": 0, "r": 0.3, "s": 0.8, "t": 1, "u": 0.08, 
			"v": 0.2, "w": 0, "x": 0.1, "y": 0.03, "z": 0.08}

	probs["k"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0.01, "g": 0, 
			"h": 0.002, "i": 1, "j": 0, "k": 0, "l": 0.3, "m": 0.1, "n": 0.1, 
			"o": 1, "p": 0, "q": 0, "r": 1, "s": 1, "t": 0.4, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["l"] = {"a": 1, "b": 0.1, "c": 0.03, "d": 1, "e": 1, "f": 0.1, "g": 0.01, 
			"h": 0, "i": 0.4, "j": 0, "k": 0.3, "l": 0.3, "m": 0.3, "n": 0.1, 
			"o": 1, "p": 0.1, "q": 0, "r": 0.01, "s": 0.5, "t": 1, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["m"] = {"a": 1, "b": 0.05, "c": 0, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0, "i": 0.6, "j": 0, "k": 0, "l": 0, "m": 0.3, "n": 0.01, 
			"o": 1, "p": 0.5, "q": 0, "r": 0.01, "s": 0.5, "t": 0, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["n"] = {"a": 1, "b": 0, "c": 0.1, "d": 1, "e": 1, "f": 0, "g": 0.8, 
			"h": 0, "i": 0.8, "j": 0, "k": 1, "l": 0, "m": 0, "n": 0.05, 
			"o": 1, "p": 0, "q": 0, "r": 0.01, "s": 0.5, "t": 1, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["o"] = {"a": 0.1, "b": 1, "c": 0.4, "d": 1, "e": 0.05, "f": 0.7, "g": 0.6, 
			"h": 0.05, "i": 0.1, "j": 0, "k": 0.07, "l": 0.8, "m": 1, "n": 1, 
			"o": 0.2, "p": 0.8, "q": 0, "r": 0.8, "s": 1, "t": 1, "u": 0.5, 
			"v": 0.3, "w": 0, "x": 0.1, "y": 0.1, "z": 0.08}

	probs["p"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0.1, "i": 1, "j": 0, "k": 0, "l": 0.5, "m": 0, "n": 0.05, 
			"o": 1, "p": 0.3, "q": 0, "r": 1, "s": 1, "t": 0.1, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["r"] = {"a": 1, "b": 0.4, "c": 0.08, "d": 1, "e": 1, "f": 0.3, "g": 0.1, 
			"h": 0, "i": 1, "j": 0, "k": 0.4, "l": 0.5, "m": 1, "n": 1, 
			"o": 1, "p": 1, "q": 0, "r": 0.04, "s": 0.5, "t": 1, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0.01}

	probs["s"] = {"a": 1, "b": 0, "c": 0.07, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0.8, "i": 1, "j": 0, "k": 0.7, "l": 0.7, "m": 0.4, "n": 0.8, 
			"o": 1, "p": 1, "q": 0, "r": 0, "s": 0.1, "t": 1, "u": 0.8, 
			"v": 0, "w": 0.004, "x": 0, "y": 0.2, "z": 0}

	probs["t"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0.8, "i": 1, "j": 0, "k": 0, "l": 0.1, "m": 0, "n": 0, 
			"o": 1, "p": 0, "q": 0, "r": 1, "s": 1, "t": 0.2, "u": 0.8, 
			"v": 0, "w": 0.4, "x": 0, "y": 0.2, "z": 0}

	probs["u"] = {"a": 0.05, "b": 1, "c": 0.4, "d": 1, "e": 0.05, "f": 0.7, "g": 0.7, 
			"h": 0, "i": 0.1, "j": 0, "k": 0.09, "l": 0.8, "m": 1, "n": 1, 
			"o": 0.05, "p": 0.8, "q": 0, "r": 1, "s": 1, "t": 1, "u": 0, 
			"v": 0.1, "w": 0, "x": 0.01, "y": 0.2, "z": 0.08}

	probs["v"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1.2, "f": 0, "g": 0, 
			"h": 0, "i": 0.4, "j": 0, "k": 0, "l": 0, "m": 0, "n": 0, 
			"o": 1, "p": 0, "q": 0, "r": 0.1, "s": 0.05, "t": 0, "u": 0, 
			"v": 0, "w": 0, "x": 0, "y": 0.2, "z": 0}

	probs["w"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0, "i": 0.7, "j": 0, "k": 0, "l": 0.1, "m": 0, "n": 0, 
			"o": 1, "p": 0, "q": 0, "r": 0, "s": 0.1, "t": 0, "u": 0.01, 
			"v": 0, "w": 0, "x": 0, "y": 0.1, "z": 0}

	probs["y"] = {"a": 1, "b": 0, "c": 0, "d": 0, "e": 1, "f": 0, "g": 0, 
			"h": 0, "i": 0.7, "j": 0, "k": 0, "l": 0.01, "m": 0, "n": 0, 
			"o": 1, "p": 0, "q": 0, "r": 0, "s": 0.1, "t": 0, "u": 0.01, 
			"v": 0, "w": 0, "x": 0, "y": 0, "z": 0}
			
	gen_full_names(10)


func draw_letter(in_dict):
	var tot_prob = 0
	var draw = rng.randf_range(0.0,1.0)
	for letter in in_dict:
		var weight = in_dict[letter]
		tot_prob += weight
	draw = draw*tot_prob
	var cur_draw = in_dict["a"]
	var cur_sum = 0
	for letter in in_dict:
		var weight = in_dict[letter]
		if draw > cur_sum:
			cur_draw = letter
		cur_sum += weight
	return cur_draw

func valid_addition(in_string, in_letter):
	if in_string == "":
		return true
	if in_letter == "":
		return false
	if not is_vowel(in_string[-1]) and not is_vowel(in_letter):
		if in_string.length() == 1:
			return false
		if not is_vowel(in_string[-2]):
			return false
	if is_vowel(in_letter):
		if len(in_string) > 1:
			if is_vowel(in_string[-1]) and is_vowel(in_string[-2]):
				return false
	return true

func gen_name(max_length):
	var string = ""
	var cur_dict = start_probs
	for i in range(max_length):
		var new_letter = draw_letter(cur_dict)
		while not valid_addition(string, new_letter):
			new_letter = draw_letter(cur_dict)
		var can_end = true
		if not valid_addition(string, "k"):
			can_end = false
		string += new_letter
		if new_letter not in probs:
			if not can_end:
				string = string.substr(0,string.size() - 1)
				i -= 1
				continue
			break
		if i == max_length - 1:
			if not can_end:
				i -= 1
				string = string.substr(0,string.length() - 1)
				continue
		if can_end and i >= 1:
			if rng.randf_range(0.0,1.0) > 0.675:
				break
		cur_dict = probs[new_letter]
	return string

func gen_suffixes(num_suffixes, min_length, max_length):
	var out_suffixes = []
	for i in range(num_suffixes):
		var new_name = ""
		while new_name.length() < min_length:
			new_name = gen_name(max_length)
		out_suffixes.append(new_name)
	return out_suffixes

func last_names(num_names, min_length, max_length, in_suffixes):
	var out_suffixes = []
	for i in range(num_names):
		var new_name = ""
		while  new_name.length() < min_length:
			new_name = gen_name(max_length)
		var suff = in_suffixes[rng.randi() % in_suffixes.size()]
		out_suffixes.append(new_name + suff)
	return out_suffixes

func gen_full_names(num_names):
	var suffixes = gen_suffixes(3, 2, 4)
	var first_names = gen_suffixes(num_names, 4, 10)
	var new_last_names = last_names(num_names, 2, 6, suffixes)
	var out_names = []
	for i in range(num_names):
		out_names.append([first_names[i], new_last_names[i]])
	return out_names
