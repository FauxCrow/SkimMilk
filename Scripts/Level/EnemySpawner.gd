extends Node

@onready var _enemy = preload("res://Assets/Prefabs/Enemy.tscn")
@onready var timer = $SpawnTimer

@export var enemy_sprites : Array[SpriteFrames] = []

@export var camera: Camera2D
var spawn_offset_y: float = 100.0

func _ready() -> void:
	if not camera:
		camera = get_viewport().get_camera_2d()
		
	await get_tree().create_timer(5.0).timeout
	spawn_enemy()

func spawn_enemy() -> void:
	var new_enemy = _enemy.instantiate()
	
	if is_instance_valid(camera):
		var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
		var cam_pos = camera.global_position
		
		var spawn_y = cam_pos.y + (viewport_size.y * 0.5) + spawn_offset_y
		var random_x = randf_range(420, 880)
		
		new_enemy.global_position = Vector2(random_x, spawn_y)
	
	get_tree().current_scene.add_child(new_enemy)
	
	var random_frames = enemy_sprites[randi() % enemy_sprites.size()]
	new_enemy.setup_enemy_frames(random_frames)
	timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
