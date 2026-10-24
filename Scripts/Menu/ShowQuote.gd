extends Label

var quote_length : float
var isTyped : bool = false;

@onready var type_timer = $AppearTimer
@onready var start_timer = $DisappearTimer

func _on_start_game_area_enter_slide() -> void:
	select_text()
	type_timer.start()

func _on_appear_timer_timeout() -> void:
	if isTyped:
		return
	
	if self.visible_characters < quote_length:
		self.visible_characters += 1
		type_timer.start()
	else:
		start_timer.start()
		isTyped = true

func select_text() -> void:
	var file = FileAccess.open("res://Assets/Texts/quote.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close() 
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		var quote_data = json.data
		
		if quote_data is Array and quote_data.size() > 0:
			text = quote_data.pick_random()
			quote_length = text.length()

func _on_disappear_timer_timeout() -> void:
	self.visible_characters = 0
	SceneManager.change_scene("res://Scenes/game_level.tscn")
