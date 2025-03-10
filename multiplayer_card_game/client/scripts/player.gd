class_name Player
extends Node2D
@onready var label: Label = $Label
@onready var player_hand_contents: Label = $player_hand_contents
@onready var deck_contents: Label = $deck_contents
@onready var test_text: Label = $test_text

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var id: int
var player_name: String
var player_hand = []
@onready var deck_reference:Deck = $"../deck"

func _process(delta: float) -> void:
	player_hand_contents.text = str(player_hand)
	deck_contents.text = str(deck_reference.deck_contents)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_multiplayer_authority(id)
	for i in get_tree().get_nodes_in_group("players"):
		if multiplayer.get_unique_id() != id:
			self.hide()
	label.text = str(id)
	pass # Replace with function body.
	
@rpc("any_peer", "call_local")
func draw_card(picked_card):
	player_hand.append(picked_card)
	print(str(id), " : ", str(picked_card))
	deck_reference.deck_contents.erase(picked_card)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_up") and multiplayer.get_unique_id() == id:
		draw_card.rpc(deck_reference.deck_contents.pick_random())
	if event is InputEventKey and event.is_action_pressed("ui_down") and multiplayer.get_unique_id() == id:
		pass
