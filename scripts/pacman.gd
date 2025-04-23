extends "res://scripts/moving_character.gd"
@onready var pacman = $AnimatedSprite2D

@export var pacman_speed = 600

func get_input_direction() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func handle_collision(collision):
	if collision and collision.get_collider().is_in_group("ghost"):
		var collider = collision.get_collider()
		if collider and collider.is_in_group("ghost"):
			pacman_got_hit()
#
func pacman_got_hit():
	# handle game over or death sequence
	print("Game Over or lose a life")

	
