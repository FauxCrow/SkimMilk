extends Node

var current_good_shards: float = 0
var current_bad_shards: float = 0

var limit_good_shards: float = 0 # will be changed on setup
var limit_bad_shards: float = 0 # will be changed on setup

@onready var sfx_player = $SFX

@onready var bad_sfx = preload("res://Assets/Audio/SFX/bad_mem.wav")
@onready var good_sfx = preload("res://Assets/Audio/SFX/good_mem.wav")

var estimate_time_per_shard: float = 3.0

@onready var fastTimer = $FastTimer
var isLong: bool = false

@export var dark_shader : ColorRect
@export var shake_shader : ColorRect

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
	
	var viewport_rect := get_viewport().get_visible_rect()
	var player_rect := player.get_collision_viewport_rect()
	var offset = 20.0
	
	if player_rect.end.y >= viewport_rect.end.y + offset or player_rect.position.y <= viewport_rect.position.y - offset:
		game_ended = true
		player.stop_movement()
		$VerticalCamera.stop_scrolling()
		call_deferred("game_lose")

func game_setup() -> void:
	var limits = GameVariables.win_requirements()
	limit_good_shards = floorf(limits[0])
	limit_bad_shards = floorf(limits[1])
	fastTimer.wait_time = estimate_time_per_shard * limit_good_shards * 1.5 # account for 50/50 chance

func add_good_shard() -> void:
	current_good_shards += 1
	good_memory.emit()
	
	sfx_player.stream = good_sfx
	sfx_player.play()
	
	temp_shake()
	add_brightness(0.5 * (current_good_shards / limit_good_shards))
	
	check_game_end()

func add_bad_shard() -> void:
	current_bad_shards += 1
	bad_memory.emit()
	
	sfx_player.stream = bad_sfx
	sfx_player.play()
	
	temp_shake()
	add_darkness(current_bad_shards / limit_bad_shards)
	
	check_game_end()

func check_game_end() -> void:
	print("Bad shard: ", current_bad_shards, " / ", limit_bad_shards)
	print("Good shard: ", current_good_shards, " / ", limit_good_shards)
	
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

func add_darkness(value : float):
	dark_shader.material.set_shader_parameter("alpha", value)

func add_brightness(value : float):
	player.get_child(0).material.set_shader_parameter("white_progress", value)

func temp_shake():
	shake_shader.visible = true
	await get_tree().create_timer(0.5).timeout
	shake_shader.visible = false
