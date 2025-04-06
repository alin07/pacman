extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

@export var speed = 5

func collide(new_pos):
	var collision_info = move_and_collide(new_pos)
	if collision_info:
		var collision_point = collision_info.get_position()
		print(collision_point)

func get_input(_delta):
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')
	var new_pos = _animated_sprite.position
	
	if right:
		_animated_sprite.play("right")
		new_pos.x = speed
	elif left:
		_animated_sprite.play("right")
		new_pos.x = -speed
	elif up:
		_animated_sprite.play("up")
		new_pos.y = -speed
	elif down:
		_animated_sprite.play("up")
		new_pos.y = speed
	else:
		_animated_sprite.stop()
	collide(new_pos)

func _process(_delta):
	get_input(_delta)
	move_and_slide()
	
