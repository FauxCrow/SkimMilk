extends Node

@export var index : int

func _ready() -> void:
	if GameVariables.check_milk(index) == 1:
		queue_free()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			GameVariables.add_milk(index)
			queue_free()
