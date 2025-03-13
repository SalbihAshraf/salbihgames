class_name PlayerHand
extends Node2D

var clicked: bool
@export var card_scene: PackedScene
@onready var hand: Array[Card]

var rank_button_reversed = true
var current_clicked_card: Card
var is_hovering_on_card: bool
const COLLISION_MASK_CARD = 1

@onready var card_normal_scale: Vector2 = Vector2(3,3)
@onready var card_max_scale: Vector2 = Vector2(3,3)

@export var hand_curve: Curve
@export var rotation_curve: Curve
var card_length: int = 96
@onready var center_screen_x = get_viewport().size.x / 2
@export var max_rotation_degrees: int
@export var x_sep: int
@export var y_min: int
@export var y_max: int

@onready var player: Player = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("wave")
	connect_signals()
	
	
	
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		#return (result[0].collider.get_parent()) 
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index

	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	
	return highest_z_card

func reorder_tree():
	for i in hand:
		i.move_to_front()

func update_hand_positions():
	var index = 0
	var cards = hand.size()
	var cards_size = card_length * (cards)

	for i in cards:
		var card = hand[i]
		card.z_index = i
		
		var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		#
		if cards == 1:
			y_multiplier = 1
			rot_multiplier = 0.0
		elif cards <= 2:
			y_multiplier = 1.1
		elif cards <= 3:
			card_length = 180
		else:
			card_length = 600/cards
		
		
		var final_y: float = 450 + y_min + y_max * y_multiplier
		
		
		var total_width = (hand.size() -1) * card_length
		var x_offset = (center_screen_x) + i * card_length - total_width / 2
		
		var card_new_position = Vector2(x_offset, final_y)
		var card_new_rotation = max_rotation_degrees * rot_multiplier
		
		animate_card_to_position(card, card_new_position)
		animate_card_to_rotation(card, card_new_rotation)
		
	reorder_tree()
		


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.2).set_ease(Tween.EASE_IN)
	await tween.finished

func animate_card_to_rotation(card, new_rotation):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "rotation_degrees", new_rotation, 0.2).set_ease(Tween.EASE_IN)
	await tween.finished

func animate_card_to_pile(card, new_position):
	var tween_pos = get_tree().create_tween()
	var tween_scale = get_tree().create_tween()
	var tween_rotate = get_tree().create_tween()
	
	GameManager.random = randf_range(-0.5, 0.5)
	await tween_scale.tween_property(card.card_face_texture, "scale", Vector2(1.5, 1.5), 0.2)
	tween_rotate.tween_property(card.card_face_texture, "rotation", GameManager.random, 0.2)
	tween_scale.tween_property(card.card_face_texture, "scale", Vector2(1, 1), 0.2)
	tween_pos.tween_property(card, "position", new_position, 0.4).set_ease(Tween.EASE_IN)
	await tween_pos.finished

func _process(delta: float) -> void:
	pass

func play_card() -> void:
	if current_clicked_card:
		var new_pos = player.client.pile.global_position
		await animate_card_to_pile(current_clicked_card, new_pos)
		hand.erase(current_clicked_card)
		player.play_card(current_clicked_card)
		remove_child(current_clicked_card)
		update_hand_positions()
		
	pass # Replace with function body.


func sort_by_suit() -> void:
	var temp_hand:Array[Card] = []
	for i in GameManager.suits:
		for j in hand:
			if j.suit == i:
				temp_hand.append(j)
	
	hand = temp_hand
	update_hand_positions()
	print("Sorted by Suit")


func sort_by_rank() -> void:
	var temp_hand:Array[Card] = []
	var sorted_by 
	if rank_button_reversed:
		sorted_by = GameManager.ranks_reversed
	else:
		sorted_by = GameManager.ranks
	for i in sorted_by:
		for j in hand:
			if j.rank == i:
				temp_hand.append(j)
	
	hand = temp_hand
	update_hand_positions()
	print("Sorted by Rank")
	rank_button_reversed = !rank_button_reversed

func shuffle_cards() -> void:
	hand.shuffle()
	update_hand_positions()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				current_clicked_card = card


func connect_signals():
	Ui.connect("suit_signal", sort_by_suit)
	Ui.connect("rank_signal", sort_by_rank)
	Ui.connect("shuffle_signal", shuffle_cards)
	Ui.connect("play_card_signal", play_card)
	
