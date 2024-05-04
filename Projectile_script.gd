extends Area2D

export var velocity = Vector2.ZERO
const BOUNDARY_MARGIN = 20

func _process(delta):
	move_and_collide(velocity * delta)

	# Destroy projectile if it goes out of bounds
	if position.y < -BOUNDARY_MARGIN:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		# Play explosion effect
		var explosion = preload("res://Explosion.tscn").instance()
		get_parent().add_child(explosion)
		explosion.position = position
		body.queue_free()  # Destroy the enemy object
		queue_free()  # Destroy the projectile
