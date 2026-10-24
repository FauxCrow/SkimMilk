extends Node

var completed_runs : float = 5 # tracks how many times you have won
var milk_count : float = 0 # tracks milk count for easter egg

# Used to check if milk plushie should be displayed in the main menu
func completed_milk() -> bool:
	return milk_count == 6

# Used to check what the win requirements in the game level should be
func win_requirements() -> Array:
	# Thank you to Desmos for being my knight in shining armour
	var win_limit = min((log((completed_runs**6)+1) / log(2)) + 10, 30)
	var lose_limit = min(log((completed_runs**3)+1) + 5, 10)
	return [win_limit, lose_limit]
