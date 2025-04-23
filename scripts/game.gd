extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()

func _ready():
	pass

# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	pass
