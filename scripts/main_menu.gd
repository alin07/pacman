extends Control

@onready var ip_input = $VBoxContainer/IPInput
@onready var status_label = $StatusLabel
@onready var name_input = $VBoxContainer/NameInput

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

func _ready():
	name_input.max_length = 10
	
func _load_lobby(name = "", ip = ""):
	print("loading lobby")
	await get_tree().create_timer(0.5).timeout
	var lobby = preload("res://scenes/lobby.tscn").instantiate()
	lobby.player_info["name"] = name 
	lobby.set("ip", ip)
	get_tree().root.add_child(lobby)
	queue_free()

func _change_scene(scene_path: String):
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child(scene)
	queue_free()  # remove main menu

func _on_host_button_pressed() -> void:
	print("host button pressed")
	var name = name_input.text.strip_edges()
	if name.is_empty():
		push_error("Please enter a name before creating a game!")
		return

	var success =  create_game()
	print(success)
	if not success:
		status_label.text = "Failed to host."
		return
	status_label.text = "Hosting..."
	print(get_preferred_ip())
	_load_lobby(name, get_preferred_ip())

func get_preferred_ip() -> String:
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.") or ip.begins_with("10.") or ip.begins_with("172."):
			return ip
	return "127.0.0.1"  # fallback (loopback)


func _on_join_button_pressed() -> void:
	print("join button pressed")
	var name = name_input.text.strip_edges()
	if name.is_empty():
		push_error("Please enter a name before joining!")
		return
	#MultiplayerManager.player_info["name"] = name
	var ip = ip_input.text.strip_edges()
	if ip == "":
		status_label.text = "Please enter an IP to join."
		return
	#MultiplayerManager.join_game(ip)
	join_game(ip)
	status_label.text = "Loading..."
	_load_lobby(name, ip)


func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error != OK:
		push_error("Failed to connect to server: %s" % error)
		return error
	multiplayer.multiplayer_peer = peer
	#player_connected.emit(players_loaded+1, player_info)
	return true

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
		
	multiplayer.multiplayer_peer = peer

	return true
