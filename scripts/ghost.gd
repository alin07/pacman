extends "res://scripts/moving_character.gd"

func get_input_direction() -> Vector2:
	# Use different input or AI here
	return Input.get_vector("ghost_left", "ghost_right", "ghost_up", "ghost_down")

func handle_collision(collision):
	if collision and collision.get_collider().is_in_group("pacman"):
		print("Ghost touched Pac-Man!")
