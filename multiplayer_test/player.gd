extends Node2D

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var ranks_reversed = [1,13,12,11,10,9,8,7,6,5,4,3,2]
var ranks_reversed_reversed = [2,3,4,5,6,7,8,9,10,11,12,13,1]
var rank_button_reversed = true

var starting_hand_count : int = 7
var id : int
var player_name : String
var score : int
@onready var start_timer: Timer = $start_timer
@onready var deck_reference = $"../deck"
# @onready var player_hand_node = $player_hand
var index: int = 100
var player_hand = []

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

var card_length: int = 96
@onready var center_screen_x = get_viewport().size.x / 2

# PLAYER HAND UPDATE VARIABLES
const CARD = preload("res://card.tscn")
@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees: int
@export var x_sep: int
@export var y_min: int
@export var y_max: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(str(name).to_int())
	start_timer.start()
	
	for j in get_tree().get_nodes_in_group("player"):
		if str(multiplayer.get_unique_id()) != j.name:
			j.hide()
	
	$draw_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_up") and multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		draw_card()
	if event is InputEventKey and event.is_action_pressed("ui_down") and multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		print(player_name)
		print(player_hand)
		#for i in deck_reference.deck:
			#print([i.suit, i.rank])
	
	if event is InputEventKey and event.is_action_pressed("ui_left") and multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var string: String
		for i in deck_reference.deck:
			string += str([i.suit, i.rank])
		print(string)
func _on_start_timer_timeout() -> void:
	pass # Replace with function body.



	

@rpc("any_peer", "call_local")
func draw_card():
	var card_to_add = deck_reference.deck.pick_random()
	player_hand.append(card_to_add)
	add_child(card_to_add)
	card_to_add.position = deck_reference.position
	var card_value = [card_to_add.suit, card_to_add.rank]
	remove_from_deck.rpc(card_value)
	_update_cards()

@rpc("any_peer", "call_local")
func remove_from_deck(card_to_remove):
	for i in deck_reference.deck:
		if i.suit == card_to_remove[0] and i.rank == card_to_remove[1]:
			deck_reference.deck.erase(i)
	pass

func _update_cards():
	var index = 0
	var cards = player_hand.size()
	var cards_size = card_length * (cards)

	for i in cards:
		var card = player_hand[i]
		card.z_index = i
		
		var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		#
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		if cards <= 3:
			card_length = 90
			y_multiplier / 2
		else:
			card_length = 600/cards
		

		var final_y: float = 200 + y_min + y_max * y_multiplier
		
		
		var total_width = (player_hand.size() -1) * card_length
		var x_offset = (center_screen_x) + i * card_length - total_width / 2
		
		var card_new_position = Vector2(x_offset, final_y)
		var card_new_rotation = max_rotation_degrees * rot_multiplier
		
		animate_card_to_position(card, card_new_position)
		animate_card_to_rotation(card, card_new_rotation)
		


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.2).set_ease(Tween.EASE_IN)
	await tween.finished

func animate_card_to_rotation(card, new_rotation):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "rotation_degrees", new_rotation, 0.2).set_ease(Tween.EASE_IN)
	await tween.finished

func _on_rank_button_pressed() -> void:
	var temp_hand = []
	var sorted_by 
	if rank_button_reversed:
		sorted_by = ranks_reversed
	else:
		sorted_by = ranks_reversed_reversed
	for i in sorted_by:
		for j in player_hand:
			if j.rank == i:
				temp_hand.append(j)
	
	player_hand = temp_hand
	_update_cards()
	print("Sorted by Rank")
	rank_button_reversed = !rank_button_reversed
	pass # Replace with function body.


func _on_suit_button_pressed() -> void:
	var temp_hand = []
	for i in suits:
		for j in player_hand:
			if j.suit == i:
				temp_hand.append(j)
	
	player_hand = temp_hand
	_update_cards()
	print("Sorted by Suit")
	pass # Replace with function body.


func _on_draw_timer_timeout() -> void:
	#print("draw")
	#if player_hand.size() < starting_hand_count:
		#draw_card()
	#else:
		#$draw_timer.stop()
	
	
	pass # Replace with function body.


func _on_shuffle_button_pressed() -> void:
	player_hand.shuffle()
	_update_cards()
	pass # Replace with function body.
