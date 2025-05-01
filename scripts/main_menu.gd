extends Control

@onready var ip_input = $VBoxContainer/IPInput
@onready var status_label = $StatusLabel
@onready var name_input = $VBoxContainer/NameInput

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 4

func _ready():
	name_input.max_length = 10
	Multiplayer.set_up_multiplayer_connection_signals()

	
func _load_char_select(name = "", id = "", ip = ""):
	print("loading char select screen")
	await get_tree().create_timer(0.5).timeout
	var char_select = preload("res://scenes/character_select.tscn").instantiate()
	var player_info = {}
	player_info["name"] = name 
	player_info["role"] = 0
	#char_select.set("ip", ip)
	Multiplayer.ip = ip
	Multiplayer.players[id] = player_info
	#Multiplayer._register_player.rpc_id(id, player_info)
	var peer = ENetMultiplayerPeer.new()
	if is_multiplayer_authority():
		print("is multiplayer authority")
		var resp = peer.create_server(Multiplayer.port, Multiplayer.max_connections)
		print(resp)
		if resp != OK:
			print("Failed to create server: %s" % resp)
			push_error("Failed to create server: %s" % resp)
			return resp
		multiplayer.multiplayer_peer = peer
		#Multiplayer.players[my_id] = player_info
		Multiplayer.player_connected.emit(id)
	else:
		print("is NOT multiplayer authority")
		var resp = peer.create_client(Multiplayer.ip, Multiplayer.port)
		print(resp)
		if resp != OK:
			print(resp)
			push_error("Failed to connect to server: %s" % resp)
			return resp
		multiplayer.multiplayer_peer = peer
		Multiplayer.player_connected.emit(id)
	
	get_tree().root.add_child(char_select)
	queue_free()

func _on_host_button_pressed() -> void:
	print("host button pressed")
	var name = name_input.text.strip_edges()
	if name.is_empty():
		push_error("Please enter a name before creating a game!")
		return

	#var success = create_game()
	#if not success:
		#status_label.text = "Failed to host."
		#return
	status_label.text = "Hosting..."
	print(get_preferred_ip())
	var my_id = multiplayer.get_unique_id()
	_load_char_select(name, my_id, get_preferred_ip())

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

	var ip = ip_input.text.strip_edges()
	if ip == "":
		status_label.text = "Please enter an IP to join."
		return

	#join_game(ip, name)
	status_label.text = "Loading..."
	var my_id = multiplayer.get_unique_id()
	_load_char_select(name, my_id, ip)
#
#
#func join_game(address = "", name = ""):
	#if address.is_empty():
		#address = DEFAULT_SERVER_IP
	#var peer = ENetMultiplayerPeer.new()
	#var error = peer.create_client(address, PORT)
	#if error != OK:
		#push_error("Failed to connect to server: %s" % error)
		#return error
	#
	#multiplayer.multiplayer_peer = peer
#
	#return true
#
#
#func create_game():
	#var peer = ENetMultiplayerPeer.new()
	#var error = peer.create_server(PORT, MAX_CONNECTIONS)
	#if error:
		#return error
#
	#multiplayer.multiplayer_peer = peer
	#return true
