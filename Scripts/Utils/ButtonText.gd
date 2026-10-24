extends Node

@export var scene_path : String

func _on_mouse_entered() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SceneManager.change_scene(scene_path)
