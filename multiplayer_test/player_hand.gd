extends Node2D
var player_hand = []
@onready var deck_reference = $"../../deck"
var index: int = 100
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	var card_to_add = deck_reference.deck.pick_random()
	player_hand.append(card_to_add)
	add_child(card_to_add)
	card_to_add.position = deck_reference.position
	remove_from_deck.rpc(card_to_add)
	_update_cards()

@rpc("any_peer", "call_local")
func remove_from_deck(card_to_remove):
	deck_reference.deck.erase(card_to_remove)

func _update_cards():
	var cards = player_hand.size()
	var cards_size = card_length * (cards)

	for i in cards:
		var card = player_hand[i]
		var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		#
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0

		var final_y: float = 200 + y_min + y_max * y_multiplier
		
		if cards <= 3:
			card_length = 90
			y_multiplier / 2
		else:
			card_length = 600/cards
		
		var total_width = (player_hand.size() -1) * card_length
		var x_offset = (center_screen_x/2) + i * card_length - total_width / 2
		
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
