extends Control

@onready var player_list = $PlayerList
@onready var status_label = $StatusLabel
@onready var start_button = $StartButton
@onready var role_selector = $RoleSelector


signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

@export var ip: String = ""

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

var player_info = {}


# to be called by lobby.
func set_up_multiplayer_connection_signals():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func join_game():
	if ip == null:
		ip = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error != OK:
		push_error("Failed to connect to server: %s" % error)
		return error
	multiplayer.multiplayer_peer = peer
	player_connected.emit(Players.players_loaded+1, player_info)
	return true


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	var my_id = multiplayer.get_unique_id()
	Players.players[my_id] = player_info
	player_connected.emit(my_id, player_info)
	return true


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	Players.players.clear()

@rpc("any_peer")
func load_game():
	var game_scene = preload("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()
	
# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	print("player loaded function")
	if multiplayer.is_server():
		print("multiplayer is server!")
		Players.players_loaded += 1
		print(Players.players_loaded)
		
func _on_player_connected(id):
	print("_on_player_connected")
	print(id)
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	Players.players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	update_player_list()

func _on_player_disconnected(id):
	print("on player disconnected")
	Players.players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	print("on connected ok")
	var peer_id = multiplayer.get_unique_id()
	Players.players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	print("on connected fail")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("on server disconnected")
	multiplayer.multiplayer_peer = null
	Players.players.clear()
	server_disconnected.emit()

func _ready():	
	print("player loaded in lobby!")
	print(Players.players)
	set_up_multiplayer_connection_signals()
	if not player_info.has("name") or player_info["name"].is_empty():
		player_info["name"] = "Player"

	if is_multiplayer_authority():
		var my_id = multiplayer.get_unique_id()
		Players.players[my_id] = player_info # or whatever variable holds the host's name
		update_player_list()
		start_button.show()
		for ip in IP.get_local_addresses():
			if ip.begins_with("192.") or ip.begins_with("10."):
				status_label.text = "Room Code / IP: " + ip
				break
		create_game()
	else:
		start_button.hide()
		join_game()
#
func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		load_game()
		rpc("load_game")


func update_player_list():
	print("Updating player list:", Players.players)
	player_list.clear()
	for id in Players.players:
		print(Players.players[id])
		var name = "%s (you)" % Players.players[id].name if id == multiplayer.get_unique_id() else "Player: %s" % Players.players[id].name
		player_list.add_item(name)
		print("Adding player:", name)

func _on_role_selector_item_selected(index: int) -> void:
	var my_id = multiplayer.get_unique_id()
	Players.players[my_id] = role_selector.get_item_text(index)
	print("players are now ")
	print(Players.players)
