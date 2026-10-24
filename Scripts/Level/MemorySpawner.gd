extends Node

@onready var _memory = preload("res://Assets/Prefabs/memory_text.tscn")

var good_memories : Array[String] = []
var bad_memories : Array[String] = []

@export var text_positions : Array[Vector2] = []

func _ready() -> void:
	setup_json()
	
	# Random order every playthrough
	good_memories.shuffle()
	bad_memories.shuffle()

func setup_json() -> void:
	var good_file = FileAccess.open("res://Assets/Texts/good_memory.json", FileAccess.READ)
	var json_string_good = good_file.get_as_text()
	good_file.close() 
	
	var json_good = JSON.new()
	var error_good = json_good.parse(json_string_good)
	
	if error_good == OK:
		var parsed_good_data = json_good.parse_string(json_string_good)
		
		if parsed_good_data is Array:
			for item in parsed_good_data:
				good_memories.append(str(item))
		else:
			print("Unexpected data format found inside JSON.")
	
	var bad_file = FileAccess.open("res://Assets/Texts/bad_memory.json", FileAccess.READ)
	var json_string_bad = bad_file.get_as_text()
	bad_file.close() 
	
	var json_bad = JSON.new()
	var error_bad = json_bad.parse(json_string_bad)
	
	if error_bad == OK:
		var parsed_bad_data = json_bad.parse_string(json_string_bad)
				
		if parsed_bad_data is Array:
			for item in parsed_bad_data:
				bad_memories.append(str(item))
		else:
			print("Unexpected data format found inside JSON.")

func spawn_good_memory() -> void:
	var text = good_memories.pop_back()
	
	var new_memory = _memory.instantiate()
	add_child(new_memory)
	new_memory.global_position = text_positions.pick_random()
	new_memory.text = text
	new_memory.label_settings.font_color = Color.WHITE

func spawn_bad_memory() -> void:
	var text = bad_memories.pop_back()
	
	var new_memory = _memory.instantiate()
	add_child(new_memory)
	new_memory.global_position = text_positions.pick_random()
	new_memory.text = text
	new_memory.label_settings.font_color = Color.RED

func _on_game_level_good_memory() -> void:
	spawn_good_memory()

func _on_game_level_bad_memory() -> void:
	spawn_bad_memory()
