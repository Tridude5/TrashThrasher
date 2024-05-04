extends Node2D

const SPAWN_INTERVAL = 1.5
var time_since_last_spawn = 0

var falling_object_scene = preload("res://FallingObject.tscn")

func _process(delta):
	time_since_last_spawn += delta

	# Check if it's time to spawn a new object
	if time_since_last_spawn >= SPAWN_INTERVAL:
		spawn_object()
		time_since_last_spawn = 0

func spawn_object():
	# Instantiate a new falling object and add it to the scene
	var new_object = falling_object_scene.instance()
	add_child(new_object)
	new_object.position.x = rand_range(0, SCREEN_WIDTH)  # Randomize x position
	new_object.position.y = -new_object.texture.get_height()  # Start above the screen

