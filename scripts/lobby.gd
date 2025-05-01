extends Control

@onready var player_list = $PlayerList
@onready var status_label = $StatusLabel
@onready var start_button = $StartButton
@onready var role_selector = $RoleSelector


@onready var players_panel = $PlayersPanel

@export var ip: String = ""

var player_info = {}

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20


func join_game():
	if ip == null:
		ip = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error != OK:
		push_error("Failed to connect to server: %s" % error)
		return error
	multiplayer.multiplayer_peer = peer
	Multiplayer.player_connected.emit(Multiplayer.players_loaded+1, player_info)
	update_player_list()
	return true


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	var my_id = multiplayer.get_unique_id()
	Multiplayer.players[my_id] = player_info
	Multiplayer.player_connected.emit(my_id, player_info)
	return true


@rpc("any_peer")
func load_game():
	var game_scene = preload("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()


func _ready():	
	print("player loaded in lobby!")
	print(Multiplayer.players)
	
	Multiplayer.set_up_multiplayer_connection_signals()
	if not player_info.has("name") or player_info["name"].is_empty():
		player_info["name"] = "Player"

	if is_multiplayer_authority():
		var my_id = multiplayer.get_unique_id()
		Multiplayer.players[my_id] = player_info # or whatever variable holds the host's name
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


func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		load_game()
		rpc("load_game")


func update_player_list():
	print("Updating player list:", Multiplayer.players)
	player_list.clear()
	for id in Multiplayer.players:
		print(Multiplayer.players[id])
		var name = "%s (you)" % Multiplayer.players[id].name if id == multiplayer.get_unique_id() else "Player: %s" % Multiplayer.players[id].name
		player_list.add_item(name)
		print("Adding player:", name)


func _on_role_selector_item_selected(index: int) -> void:
	var my_id = multiplayer.get_unique_id()
	Multiplayer.players[my_id] = role_selector.get_item_text(index)
	print("players are now ")
	print(Multiplayer.players)
