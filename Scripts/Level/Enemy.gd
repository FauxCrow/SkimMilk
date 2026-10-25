extends Node

@onready var sprite_2d = $EnemySprite

@export var speed: float = 100.0
var direction: Vector2 = Vector2.UP

func setup_enemy_frames(frames : SpriteFrames) -> void:
	sprite_2d.sprite_frames = frames
	
	var anim_names = sprite_2d.sprite_frames.get_animation_names()
	if anim_names.size() > 0:
		sprite_2d.play(anim_names[0])

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed * delta

func _on_expiry_timer_timeout() -> void:
	queue_free()
