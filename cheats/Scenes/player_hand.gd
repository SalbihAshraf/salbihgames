extends Node2D

const INITIAL_HAND_COUNT = 5
const CARD_WIDTH = 90
const HAND_Y_POSITION = 500
const CARD_SCENE_PATH = "res://Scenes/card.tscn"

var player_hand = []
var center_screen_x
var hand_count:int = 0
var card_width = 90



@onready
var deck_reference = $"../deck"
var card_scene = preload(CARD_SCENE_PATH)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	for i in range(INITIAL_HAND_COUNT):
		create_card()
		

func create_card():
	
	var new_card = card_scene.instantiate()
		
	new_card.name = "Card"
	new_card.card = deck_reference.deck.pick_random()
	new_card.suit = new_card.card[0]
	new_card.rank = new_card.card[1]
	new_card.position = deck_reference.position
	$"../CardManager".add_child(new_card)
	deck_reference.deck.erase(new_card.card)
	add_card_to_hand(new_card)
	hand_count += 1
	
	print(deck_reference.deck)
	print("\n")
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_up"):
		create_card()
	if event is InputEventKey and event.is_action_pressed("ui_down"):
		if hand_count > 0:
			remove_card_from_hand(player_hand[0], false)
		
		

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)
		

func update_hand_positions():
	for i in range(player_hand.size()):
		# get new card position based on index
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	if hand_count < 5:
		card_width = 140
	else:
		card_width = 720/hand_count
	var total_width = (player_hand.size() -1) * card_width
	var x_offset = center_screen_x + index * card_width - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
	await tween.finished

func remove_card_from_hand(card, slot_found):
	if card in player_hand:
		player_hand.erase(card)
		card.stop_animation()
		if !slot_found:
			animate_card_to_position(card, deck_reference.position) 
			deck_reference.deck.append([card.suit, card.rank])
			
		
		
		
		print(deck_reference.deck)
		print("\n")
		
		hand_count -= 1
		update_hand_positions()
