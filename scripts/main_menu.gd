extends Control

@onready var ip_input = $VBoxContainer/IPInput
@onready var status_label = $StatusLabel

func _load_lobby():
	print("loading lobby")
	await get_tree().create_timer(1.0).timeout  # optional pause
	var lobby = preload("res://scenes/lobby.tscn").instantiate()
	get_tree().root.add_child(lobby)
	queue_free()
	
func _change_scene(scene_path: String):
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child(scene)
	queue_free()  # remove main menu


func _on_host_button_pressed() -> void:
	print("host button pressed")
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(12345)
	if result != OK:
		status_label.text = "Failed to start server."
		return
	
	multiplayer.multiplayer_peer = peer
	status_label.text = "Hosting game..."
	_load_lobby()


func _on_join_button_pressed() -> void:
	print("join button pressed")
	var ip = ip_input.text.strip_edges()
	if ip == "":
		status_label.text = "Please enter an IP to join."
		return

	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(ip, 12345)
	if result != OK:
		status_label.text = "Failed to join server."
		return
	
	multiplayer.multiplayer_peer = peer
	status_label.text = "Joining game..."
	_load_lobby()
