extends Camera2D

@export var target: SlidingPlayer
@export var fixed_world_x: float = 640.0
@export_range(1.0, 2000.0, 1.0) var base_scroll_speed: float = 400.0
@export_range(0.2, 0.8, 0.05) var starting_screen_ratio: float = 0.5

func _ready() -> void:
	process_physics_priority = 1 # So that player moves first
	process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	position_smoothing_enabled = false
	scroll_speed = base_scroll_speed

	if is_instance_valid(target):
		var height := get_viewport_rect().size.y / zoom.y
		global_position = Vector2(
			fixed_world_x, target.global_position.y + (0.5 - starting_screen_ratio) * height
		)
	force_update_scroll()


@export_range(0.0, 0.9, 0.05) var player_speed_response: float = 0.35
@export_range(1.0, 3000.0, 1.0) var scroll_acceleration: float = 600.0
@export_range(0.0, 0.3, 0.01) var upper_safe_ratio: float = 0.12

var scroll_speed: float = 0.0
var scrolling_stopped: bool = false

func _physics_process(delta: float) -> void:
	if scrolling_stopped or not is_instance_valid(target):
		return

	var previous_y := global_position.y
	var desired_speed := lerpf(base_scroll_speed, target.velocity.y, player_speed_response)
	scroll_speed = move_toward(scroll_speed, maxf(desired_speed, 1.0), scroll_acceleration * delta)
	global_position.x = fixed_world_x
	global_position.y += scroll_speed * delta
	force_update_scroll()

	# Slow the camera if braking brings the player too close to the top
	var safe_top := get_viewport_rect().position.y + get_viewport_rect().size.y * upper_safe_ratio
	var player_top := target.get_collision_viewport_rect().position.y
	if player_top < safe_top:
		global_position.y -= (safe_top - player_top) / zoom.y
		force_update_scroll()
	scroll_speed = maxf((global_position.y - previous_y) / delta, 0.0)


func stop_scrolling() -> void:
	scrolling_stopped = true
	scroll_speed = 0.0
