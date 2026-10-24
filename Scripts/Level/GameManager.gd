extends Node

var current_good_shards: float = 0
var current_bad_shards: float = 0

var limit_good_shards: float = 0 # will be changed on setup
var limit_bad_shards: float = 0 # will be changed on setup

var estimate_time_per_shard: float = 3.0

@onready var fastTimer = $FastTimer
var isLong: bool = false

signal good_memory
signal bad_memory

func _ready() -> void:
	process_physics_priority = 2 # Check after the player and camera have moved
	game_setup()
	fastTimer.start()

@onready var player: SlidingPlayer = $Player
var game_ended: bool = false

# Reaching the bottom of the screen triggers the bad ending
func _physics_process(_delta: float) -> void:
	if game_ended:
		return
	if player.get_collision_viewport_rect().end.y >= get_viewport().get_visible_rect().end.y:
		game_ended = true
		player.stop_movement()
		$VerticalCamera.stop_scrolling()
		call_deferred("game_lose")

func game_setup() -> void:
	var limits = GameVariables.win_requirements()
	limit_good_shards = floorf(limits[0])
	limit_bad_shards = floorf(limits[1])
	fastTimer.wait_time = estimate_time_per_shard * limit_good_shards

func add_good_shard() -> void:
	current_good_shards += 1
	good_memory.emit()
	
	# TODO: Affect player's brightness shader
	
	check_game_end()

func add_bad_shard() -> void:
	current_bad_shards += 1
	bad_memory.emit()
	
	# TODO: Affect screen darkness shader
	
	check_game_end()

func check_game_end() -> void:
	if current_bad_shards >= limit_bad_shards:
		game_lose()
	
	if current_good_shards >= limit_good_shards:
		game_win()

func game_win() -> void:
	if isLong:
		SceneManager.change_scene("res://Scenes/EndGame/good_ending.tscn")
	else:
		SceneManager.change_scene("res://Scenes/EndGame/neutral_ending.tscn")

func game_lose() -> void:
	SceneManager.change_scene("res://Scenes/EndGame/bad_ending.tscn")

func _on_fast_timer_timeout() -> void:
	isLong = true
