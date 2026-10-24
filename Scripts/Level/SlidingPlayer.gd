class_name SlidingPlayer
extends CharacterBody2D

@export_group("Downhill")
@export_range(1.0, 2000.0, 1.0) var minimum_slide_speed: float = 120.0
@export_range(1.0, 2000.0, 1.0) var maximum_slide_speed: float = 650.0
@export_range(1.0, 2000.0, 1.0) var starting_slide_speed: float = 400.0

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	wall_min_slide_angle = 0.0
	minimum_slide_speed = maxf(minimum_slide_speed, 1.0)
	maximum_slide_speed = maxf(maximum_slide_speed, minimum_slide_speed)
	velocity.y = clampf(starting_slide_speed, minimum_slide_speed, maximum_slide_speed)


@export_range(0.0, 2000.0, 1.0) var downhill_acceleration: float = 260.0
@export_range(0.0, 2000.0, 1.0) var speed_up_acceleration: float = 300.0
@export_range(0.0, 5.0, 0.05) var downhill_drag: float = 0.65
@export_range(0.0, 3000.0, 1.0) var brake_strength: float = 350.0

@export_group("Steering")
@export_range(0.0, 1000.0, 1.0) var maximum_steer_speed: float = 300.0
@export_range(0.0, 4000.0, 1.0) var steer_acceleration: float = 1200.0
@export_range(0.0, 20.0, 0.1) var sideways_drag: float = 3.0

var movement_stopped: bool = false

func _physics_process(delta: float) -> void:
	if movement_stopped:
		return

	# Downhill movement
	var acceleartion := downhill_acceleration

	if Input.is_action_pressed("slide_brake"):
		acceleartion -= brake_strength
	elif Input.is_action_pressed("slide_speed_up"):
		acceleartion += speed_up_acceleration

	var new_y_speed := velocity.y + acceleartion * delta
	new_y_speed /= 1.0 + downhill_drag * delta
	new_y_speed = clampf(new_y_speed, minimum_slide_speed, maximum_slide_speed)

	# Left and right steering + friction
	var steer := Input.get_axis("slide_left", "slide_right")
	var new_x_speed := (velocity.x + steer * steer_acceleration * delta)
	new_x_speed /= 1.0 + sideways_drag * delta
	new_x_speed = clampf(new_x_speed, -maximum_steer_speed, maximum_steer_speed)

	_move_along_slide(new_x_speed, new_y_speed)


func _move_along_slide(new_x_speed: float, acceleration: float) -> void:
	# Move sideways first so that when you hit a wall it doesn't affect ur falling speed
	velocity = Vector2(new_x_speed, 0.0)
	move_and_slide()
	if is_on_wall():
		new_x_speed = 0.0

	velocity = Vector2(0.0, acceleration)
	move_and_slide()
	velocity.x = new_x_speed


@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Get the player's collision bounds on screen
func get_collision_viewport_rect() -> Rect2:
	var screen_transform = collision_shape.get_global_transform_with_canvas()
	return screen_transform * collision_shape.shape.get_rect()


func stop_movement() -> void:
	movement_stopped = true
	velocity = Vector2.ZERO
