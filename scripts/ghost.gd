extends "res://scripts/moving_character.gd"

func get_input_direction() -> Vector2:
	#return Input.get_vector("ghost_left", "ghost_right", "ghost_up", "ghost_down")
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func handle_collision(collision):
	if collision and collision.get_collider().is_in_group("pacman"):
		print("Ghost touched Pac-Man!")
