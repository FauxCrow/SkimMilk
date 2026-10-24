extends Node

@onready var _shard = preload("res://Assets/Prefabs/shard.tscn")
@onready var spawn_timer = $SpawnTimer

@export var camera: Camera2D
@export var good_shard_sprite : Array[Texture] = []
@export var bad_shard_sprite : Array[Texture] = []

var spawn_offset_y: float = 100.0

func _ready() -> void:
	if not camera:
		camera = get_viewport().get_camera_2d()
		
	await get_tree().create_timer(2.0).timeout
	spawn_shard()
	
func spawn_shard() -> void:
	var new_shard = _shard.instantiate()
	
	if is_instance_valid(camera):
		var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
		var cam_pos = camera.global_position
		
		var spawn_y = cam_pos.y + (viewport_size.y * 0.5) + spawn_offset_y
		var random_x = randf_range(420, 880)
		
		new_shard.global_position = Vector2(random_x, spawn_y)
	
	get_tree().current_scene.add_child(new_shard)
	
	if (randi() % 2 == 1):
		new_shard.setup_shard(true, good_shard_sprite.pick_random())
	else:
		new_shard.setup_shard(false, bad_shard_sprite.pick_random())
	
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_shard()
	
	spawn_timer.start()
