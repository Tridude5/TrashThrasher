extends Node2D

@export var SPAWN_INTERVAL = 1.5
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
	new_object.position.x = randf_range(0, get_viewport().get_visible_rect().size.x)  # Randomize x position
	new_object.position.y = -10  # Start above the screen.
	var rotation_degrees = randf_range(0, 359)
	new_object.rotation = rotation_degrees

