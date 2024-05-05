extends CharacterBody2D

func _process(delta):
	
# Check if the object has reached the bottom of the screen
	if position.y > SCREEN_HEIGHT:
		queue_free()  # Destroy the object if it's below the screen
