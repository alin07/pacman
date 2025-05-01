extends Control

@onready var players_panel = $PlayersPanel
@onready var start_button = $StartButton
@onready var status_label = $StatusLabel

var player_info = {}
var claimed_roles = {}

func _ready():
	print("inside char_Select ready func")

	start_button.hide()
	
	#Multiplayer.players[my_id] = player_info
		
	
	
	Multiplayer.set_up_multiplayer_connection_signals()
	var id = multiplayer.get_unique_id()
	
	setup_players()

func setup_players():
	clear_children()
	print(Multiplayer.players)
	for id in Multiplayer.players:
		print("peer: ")
		print(id)
		create_player_slot(id)
	#create_player_slot(multiplayer.get_unique_id()) # Add yourself

func clear_children() -> void:
	var children = players_panel.get_children()
	for child in children:
		child.queue_free()

func create_player_slot(player_id):
	var slot = preload("res://scenes/player_slot.tscn").instantiate()
	slot.init(player_id)
	players_panel.add_child(slot)
	#Multiplayer.players[player_id] = player_info


func _on_start_button_pressed():
	# Verify everyone is ready, then start game
	pass
