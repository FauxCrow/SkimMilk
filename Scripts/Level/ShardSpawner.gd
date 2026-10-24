extends Node

@onready var _shard = preload("res://Assets/Prefabs/shard.tscn")
@onready var spawn_timer = $SpawnTimer

@export var good_shard_sprite : Array[Texture] = []
@export var bad_shard_sprite : Array[Texture] = []

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	spawn_shard()
	
func spawn_shard() -> void:
	var new_shard = _shard.instantiate()
	add_child(new_shard)
	
	if (randi() % 2 == 1):
		new_shard.setup_shard(true, good_shard_sprite.pick_random())
	else:
		new_shard.setup_shard(false, bad_shard_sprite.pick_random())
	
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_shard()
	
	spawn_timer.start()
