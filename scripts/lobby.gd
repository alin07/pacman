extends Control

@onready var player_list = $VBoxContainer/PlayerList
@onready var status_label = $StatusLabel
@onready var start_button = $VBoxContainer/StartButton

func _ready():
	if is_multiplayer_authority():
		start_button.show()
	else:
		start_button.hide()

	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	_on_player_connected(multiplayer.get_unique_id())  # add self to list

func _on_player_connected(id):
	player_list.add_item("Player %s" % id)

func _on_player_disconnected(id):
	for i in player_list.item_count:
		if player_list.get_item_text(i) == "Player %s" % id:
			player_list.remove_item(i)
			break

func _on_StartGame_pressed():
	if not is_multiplayer_authority():
		return

	# Load the game scene and switch
	var game_scene = preload("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()  # remove the lobby
