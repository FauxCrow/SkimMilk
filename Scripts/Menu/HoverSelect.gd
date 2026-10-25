extends Node

var isClick : bool = false
var is_hovered : bool = false
var current_tween : Tween = null

@onready var darknessShader = $SlideEntranceSprite/DarknessShader
@onready var darknessShape = $SlideEntranceSprite
@onready var enterText = $StartText
@onready var milkPlush = $PlushReward
@onready var childHead = $ChildHead

@export var BGMPlayer : AudioStreamPlayer

signal enter_slide

func _ready() -> void:
	if GameVariables.completed_milk():
		milkPlush.visible = true

func _on_mouse_entered() -> void:
	if isClick:
		return
	
	is_hovered = true
	await get_tree().create_timer(0.2).timeout
	
	if not is_hovered or isClick:
		return
	
	tween_movement(0.3, 3, darknessShader, show_text)

func _on_mouse_exited() -> void:
	if isClick:
		return
	
	is_hovered = false
	
	await get_tree().create_timer(0.2).timeout
 
	if is_hovered or isClick:
		return
	
	hide_text()
	tween_movement(0.3, 1, darknessShader)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if isClick:
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isClick = true
			childHead.move_out()
			darken_anim()

func tween_movement(time : float, value : float, sprite : Sprite2D, callback: Callable = Callable()) -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	current_tween = create_tween()
	
	current_tween.set_trans(Tween.TRANS_SINE)
	current_tween.set_ease(Tween.EASE_OUT)
	
	current_tween.tween_property(sprite, "scale", Vector2(value, value), time)
	await current_tween.finished
	
	if callback.is_valid():
		callback.call()

func darken_anim():
	fade_out_audio(3.0)
	hide_text()
	tween_movement(0.5, 6, darknessShape, signal_complete)

func fade_out_audio(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(BGMPlayer, "volume_db", -80.0, duration)

func signal_complete():
	enter_slide.emit()

func show_text():
	enterText.visible = true

func hide_text():
	enterText.visible = false
