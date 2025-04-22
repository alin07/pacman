extends "res://scripts/moving_character.gd"
@onready var pacman = $AnimatedSprite2D

#@export var speed = 600

func get_input_direction() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func handle_collision(collision):
	if collision and collision.get_collider().is_in_group("ghost"):
		var collider = collision.get_collider()
		if collider and collider.is_in_group("ghost"):
			pacman_got_hit()

#func _physics_process(delta):
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") 
	#if input_dir != Vector2.ZERO:
		#var motion = input_dir.normalized() * speed * delta
		#var collision = move_and_collide(motion)
		#position.x = wrapf(position.x, 25, 1800)
		#
		#var anim_direction = input_dir.round()
		#if direction_animations.has(anim_direction):
			#pacman.play(direction_animations[anim_direction])
		#
		#if collision and collision.get_collider().is_in_group("ghost"):
			#var collider = collision.get_collider()
			#if collider and collider.is_in_group("pacman"): 
				#pacman_got_hit()
#
#
func pacman_got_hit():
	# handle game over or death sequence
	print("Game Over or lose a life")


func _process(_delta):
	#get_input(delta)
	pass
	
