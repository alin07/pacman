extends CharacterBody2D

@export var speed = 600
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction_animations := {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

func _physics_process(delta):
	# this node is controlled by this peer — go ahead and process input
	if not is_multiplayer_authority():
		return
	
	var input_dir = get_input_direction()
	if input_dir != Vector2.ZERO:
		var motion = input_dir.normalized() * speed * delta
		var collision = move_and_collide(motion)
		position.x = wrapf(position.x, 25, 1800)
		
		var anim_direction = input_dir.round()
		if direction_animations.has(anim_direction):
			anim_sprite.play(direction_animations[anim_direction])
		
		handle_collision(collision)

# Override this in child classes
func get_input_direction() -> Vector2:
	return Vector2.ZERO

# Override this in child classes
func handle_collision(collision): 
	pass
