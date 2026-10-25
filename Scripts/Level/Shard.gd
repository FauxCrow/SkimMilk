extends Node2D

var isGood : bool

@onready var sprite_2d = $ShardSprite

@export var speed: float = 100.0
var direction: Vector2 = Vector2.UP

# Used by shard spawner to set what kind of shard this is
func setup_shard(type : bool, sprite : Texture) -> void:
	isGood = type
	sprite_2d.texture = sprite

# Handles movement of shard across screen
func _physics_process(delta: float) -> void:
	#global_position += direction * speed * delta
	pass

# Used to detect if player has been hit
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		if isGood:
			get_tree().call_group("GameManager", "add_good_shard")
		else:
			get_tree().call_group("GameManager", "add_bad_shard") 
		
		queue_free()

func _on_expiry_timer_timeout() -> void:
	queue_free()
