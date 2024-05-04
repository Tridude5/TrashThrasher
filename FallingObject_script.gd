extends CharacterBody2D

const FALL_SPEED = 200

func _process(delta):
	# Move the falling object downwards
	move_and_collide(Vector2(0, FALL_SPEED * delta))

	# Check if the object has reached the bottom of the screen
	if position.y > SCREEN_HEIGHT:
		queue_free()  # Destroy the object if it's below the screen
