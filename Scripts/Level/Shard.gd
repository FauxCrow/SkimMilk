extends Node2D

var isGood : bool

@onready var sprite_2d = $ShardSprite

# Used by shard spawner to set what kind of shard this is
func setup_shard(type : bool, sprite : Sprite2D) -> void:
	isGood = type
	sprite_2d.texture = sprite

func _ready() -> void:
	var _position = Vector2(randf_range(420,880), 800)
	set_position(_position)

# Handles movement of shard across screen
func _process(delta: float) -> void:
	
	# TODO: Shard upwards movement
	pass

# Used to detect if player has been hit
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("DEBUG: Hit player!!")
		
		if isGood:
			get_tree().call_group("GameManager", "add_good_shard")
		else:
			get_tree().call_group("GameManager", "add_bad_shard") 
		
		queue_free()

# Used to destroy shard after some time (left screen)
func _on_expiry_timer_timeout() -> void:
	queue_free()
