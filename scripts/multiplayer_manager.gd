class_name MultiplayerManager extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected

var player

var ip
var port = 8088
var max_connections = 4

var players = {}
var players_loaded = 0
#var roles = {"pacman": 0, "blinky": 1, "clyde": 2, "inky":3, "pinky":4}
var roles = {0:"pacman", 1:"blinky", 2:"clyde", 3:"inky", 4:"pinky"}

func set_up_multiplayer_connection_signals():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	players.clear()

func _on_player_disconnected(id):
	print("on player disconnected")
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	print("on connected ok")
	var peer_id = multiplayer.get_unique_id()
	player_connected.emit(peer_id)

func _on_connected_fail():
	print("on connected fail")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("on server disconnected")
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	
# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	print("player loaded function")
	if multiplayer.is_server():
		print("multiplayer is server!")
		players_loaded += 1
		print(players_loaded)

func _on_player_connected(id):
	print("_on_player_connected")
	print(id)
	player_connected.emit(players_loaded+1)
	_register_player.rpc_id(id)

@rpc("any_peer", "reliable")
func _register_player():
	print("in register player function")
	var new_player_id = multiplayer.get_remote_sender_id()
	#players[new_player_id] = new_player_info
	print("registering player")
	#print(new_player_info)
	player_connected.emit(new_player_id)

@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)
