extends Node2D

const SPAWN_INTERVAL = 1.5
var time_since_last_spawn = 0

var falling_object_scene = preload("res://Scenes/TrashObject.tscn")

func _process(delta):
	time_since_last_spawn += delta

	# Check if it's time to spawn a new object
	if time_since_last_spawn >= SPAWN_INTERVAL:
		spawn_object()
		time_since_last_spawn = 0

func spawn_object():
	# Instantiate a new falling object and add it to the scene
	var new_object = falling_object_scene.instantiate()
	add_child(new_object)
	new_object.position.x = randf_range(0, 600)  # Randomize x position
	new_object.position.y = 0  # Start above the screen

