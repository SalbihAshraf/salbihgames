class_name Player
extends Node2D

@export var player_hand_scene: PackedScene
@export var card_scene: PackedScene

@onready var players_cards: Label = $players_cards
@onready var player_hand_node: PlayerHand = %player_hand

@onready var client: Client = self.get_parent()

var suits: Array[String] = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks: Array[int] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var id: int
var player_name: String
var player_hand = []:
	set(val):
		if val.size() > player_hand.size():
			player_hand_node.add_card(val.back())
		else:
			player_hand_node.remove_card()
		
@onready var deck_reference:Deck = $"../Control/deck"

func _process(delta: float) -> void:
	display_players_cards()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_multiplayer_authority(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() != id:
		self.hide()
		remove_child(player_hand_node)
	else:
		DisplayServer.window_set_title(player_name + ":" + str(id))
	pass # Replace with function body.
	


@rpc("any_peer","call_local")
func add_to_hand(picked_card):
	player_hand.append(picked_card)
	print(str(id), " : ", str(picked_card))
	deck_reference.deck_contents.erase(picked_card)
	if multiplayer.get_unique_id() == id:
		var card: Card = card_scene.instantiate()
		card.suit = picked_card[0]
		card.rank = picked_card[1]
		player_hand_node.hand.append(card)
		card.position = deck_reference.position
		player_hand_node.add_child(card)
		player_hand_node.update_hand_positions()

func draw_card():
	var picked_card = deck_reference.deck_contents.pick_random()
	add_to_hand.rpc(picked_card)
	
func play_card(card):
	display_card.rpc(card.suit, card.rank)
	player_hand.erase([card.suit, card.rank])

@rpc("any_peer", "call_local")
func display_card(suit, rank):
	var new_card: Card = card_scene.instantiate()
	new_card.suit = suit
	new_card.rank = rank
	new_card.rotation += randf_range(-1, 1)
	
	client.pile.contents.append([suit, rank])
	client.pile.add_child(new_card)

func display_players_cards():
	var string = ""
	for i in get_tree().get_nodes_in_group("players"):
		string += (i.player_name + str(i.player_hand) + "\n")
	string += (str(client.pile.contents) + "\n")
	players_cards.text = string

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_up") and multiplayer.get_unique_id() == id:
		draw_card()
	if event is InputEventKey and event.is_action_pressed("ui_down") and multiplayer.get_unique_id() == id:
		pass
