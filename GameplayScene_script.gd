extends Node2D

# Constants for screen dimensions
const SCREEN_WIDTH = 800
const SCREEN_HEIGHT = 600

func _ready():
	# Set the screen size
	#get_viewport().size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	
	# Add the player character
	var player = Player.new()
	add_child(player)
