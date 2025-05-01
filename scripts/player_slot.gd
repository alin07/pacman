extends VBoxContainer

var player_info = {}

@onready var player_name = $PlayerName
@onready var char_sprite = $CharacterContainer/HBoxContainer/CharacterSprite

const pacman = "res://assets/pacman-right/1.png"
const blinky = "res://assets/ghosts/blinky.png"
const clyde = "res://assets/ghosts/clyde.png"
const inky = "res://assets/ghosts/inky.png"
const pinky = "res://assets/ghosts/pinky.png"

var role_textures = {0: pacman, 1:blinky, 2:clyde, 3:inky, 4:pinky}
var current_role = 0

func _ready() -> void:
	# TODO: MAKE SPRITES ANIMATED
	char_sprite.size.x = 500
	char_sprite.size.y = 500
	char_sprite.set_texture(load(role_textures[current_role]))
	player_name.text = player_info["name"]
	#player_name.text = Multiplayer.players[id]["name"]

func init(player_id: int) -> void:
	print(Multiplayer.players)
	player_info = Multiplayer.players[player_id]
	print(player_info)
	print(player_info["name"])



func _on_left_button_pressed() -> void:
	var id = multiplayer.get_unique_id()
	current_role -= 1
	if current_role < 0:
		current_role = 4
	Multiplayer.players[id]["role"] = current_role
	
	char_sprite.set_texture(load(role_textures[current_role]))

func _on_right_button_pressed() -> void:
	var id = multiplayer.get_unique_id()
	current_role = (current_role + 1) % 5
	Multiplayer.players[id]["role"] = current_role
	char_sprite.set_texture(load(role_textures[current_role]))
