extends Parallax2D

@export var scroll_speed: float = 100.0

func _process(delta: float) -> void:
	# Moves the offset vertically over time
	scroll_offset.y -= scroll_speed * delta
