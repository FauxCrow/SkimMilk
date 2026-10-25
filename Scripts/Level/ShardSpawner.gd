extends Node

@onready var _shard = preload("res://Assets/Prefabs/shard.tscn")
@onready var spawn_timer = $SpawnTimer

@export var camera: Camera2D

@export var bad_sprite_sheet : Texture2D
@export var good_sprite_sheet : Texture2D
var h_frames : int = 4
var v_frames : int = 1
var sprite_size : Vector2 = Vector2(128, 128)

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
		var random_atlas = get_random_atlas_texture(good_sprite_sheet)
		new_shard.setup_shard(true, random_atlas)
	else:
		var random_atlas = get_random_atlas_texture(bad_sprite_sheet)
		new_shard.setup_shard(false, random_atlas)
	
	spawn_timer.start()

func get_random_atlas_texture(sprite_sheet : Texture2D) -> AtlasTexture:
	if not sprite_sheet:
		return null
	
	var total_sprites = h_frames * v_frames
	var random_index = randi() % total_sprites
	
	var col = random_index % h_frames
	var row = random_index / h_frames
	
	var atlas = AtlasTexture.new()
	atlas.atlas = sprite_sheet
	
	atlas.region = Rect2(
		Vector2(col * sprite_size.x, row * sprite_size.y),
		sprite_size
	)
	
	return atlas

func _on_spawn_timer_timeout() -> void:
	spawn_shard()
	spawn_timer.start()
