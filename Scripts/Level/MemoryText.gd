extends Node

func _ready() -> void:
	# TODO: Set position of memory spawns
	pass

func tween_visibility() -> void:
	var current_tween = create_tween()
	
	current_tween.set_trans(Tween.TRANS_SINE)
	current_tween.set_ease(Tween.EASE_OUT)
	
	current_tween.tween_property(self, "modulate:a", 0.0, 3.0)
	await current_tween.finished
	
	queue_free()
