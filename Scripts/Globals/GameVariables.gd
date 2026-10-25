extends Node

var completed_runs : float = 0 # tracks how many times you have won
var milk_track : Array = [0,0,0,0,0,0]

func check_milk(index : int) -> int:
	return milk_track[index]

func add_milk(index : int) -> void:
	milk_track[index] = 1

# Used to check if milk plushie should be displayed in the main menu
func completed_milk() -> bool:
	var all_higher = milk_track.all(func(x): return x == 1)
	return all_higher

# Used to check what the win requirements in the game level should be
func win_requirements() -> Array:
	# Thank you to Desmos for being my knight in shining armour
	var win_limit = min((log((completed_runs**6)+1) / log(2)) + 10, 30)
	var lose_limit = min(log((completed_runs**3)+1) + 5, 10)
	return [win_limit, lose_limit]
