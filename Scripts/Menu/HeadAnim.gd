extends Node

var move_distance: float = 5.0
var duration: float = 1.0

var current_tween : Tween = null

func _ready() -> void:
	current_tween = create_tween().set_loops()
	current_tween.set_ease(Tween.EASE_IN_OUT)
	current_tween.set_trans(Tween.TRANS_SINE)
	
	current_tween.tween_property(self, "position:y", self.position.y - move_distance, duration)
	current_tween.tween_property(self, "position:y", self.position.y + move_distance, duration)

func move_out() -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.set_ease(Tween.EASE_IN_OUT)
	current_tween.set_trans(Tween.TRANS_SINE)
	
	current_tween.tween_property(self, "position:y", self.position.y + move_distance*50, duration)
