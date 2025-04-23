extends Node2D

var roles = {1: "pacman", 2: "ghost", 3: "ghost"}  # Example: {1: "pacman", 2: "ghost", 3: "ghost"}
var players = {}
const PACMAN_SCENE = preload("res://scenes/pacman.tscn")
const GHOST_SCENE = preload("res://scenes/blinky.tscn")

@rpc("authority")
func load_game():
	var game_scene = preload("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(game_scene)
	# Assign host (server) as Pac-Man
	var host_id = multiplayer.get_unique_id()
	roles[host_id] = "pacman"
	for id in players:
		if id != host_id:
			roles[id] = "ghost"
	# Optionally broadcast roles to all players
	rpc("set_roles", roles)
	queue_free()  # Clean up lobby


@rpc("any_peer", "reliable")
func set_roles(received_roles: Dictionary):
	roles = received_roles
	print("Received roles: ", roles)
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()

func _ready():
	if multiplayer.is_server():
		for id in roles:
			var player_scene = GHOST_SCENE
			if roles[id] == "pacman":
				player_scene = PACMAN_SCENE
			var player_instance = player_scene.instantiate()
			add_child(player_instance)
			player_instance.set_multiplayer_authority(id)
			#player_instance.position = roles[id] == "pacman" ? Vector2(100, 100) : Vector2(randi() % 400, randi() % 400)

# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	pass
