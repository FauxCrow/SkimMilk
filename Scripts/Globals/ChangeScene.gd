extends Node

func change_scene(scene_path : String) -> void:
	var new_scene_resource = load(scene_path)
	if not new_scene_resource:
		printerr("Failed to load scene at: ", scene_path)
		return
		
	var new_scene_instance = new_scene_resource.instantiate()
	
	# Optional: Can pass data to the new scene here
	# new_scene_instance.player_health = current_health
	
	var current_scene = get_tree().current_scene
	
	get_tree().root.add_child(new_scene_instance)
	get_tree().current_scene = new_scene_instance
	
	if current_scene:
		current_scene.queue_free()
