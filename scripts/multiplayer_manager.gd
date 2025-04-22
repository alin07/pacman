extends Node

var port = 8910

func host_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	print("Hosting on port ", port)

func join_game(ip_address):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = peer
	print("Joining ", ip_address)

func spawn_player(peer_id, role):  # role is "pacman" or "ghost"
	var scene = role == "pacman" ? preload("res://Pacman.tscn") : preload("res://Ghost.tscn")
	var player = scene.instantiate()
	add_child(player)
	player.set_multiplayer_authority(peer_id)
