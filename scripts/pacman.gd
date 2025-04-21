extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed = 600

func collide(new_pos):
	var collision_info = move_and_collide(new_pos)
	if collision_info:
		var collision_point = collision_info.get_position()

func get_input(_delta):
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')
	var new_pos = _animated_sprite.position

	if up:
		_animated_sprite.play("up")
		velocity.y = -speed
		velocity.x = 0
	elif down:
		_animated_sprite.play("down")
		velocity.y = speed
		velocity.x = 0
	elif left:
		_animated_sprite.play("left")
		velocity.x = -speed
		velocity.y = 0
	elif right:
		_animated_sprite.play("right")
		velocity.x = speed
		velocity.y = 0
	else:
		velocity.x = 0
		velocity.y = 0
		_animated_sprite.stop()
	collide(new_pos)
	position.x = wrapf(position.x, 25, 1800)

func _process(delta):
	get_input(delta)
	move_and_slide()
