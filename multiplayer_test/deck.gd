extends Node2D

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]

@onready var deck = []
@export var card_scene: PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_new_deck()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_new_deck():
	for i in suits:
		for j in ranks:
			var current_card = card_scene.instantiate()
			current_card.suit = i
			current_card.rank = j
			deck.append(current_card)

func shuffle_deck():
	deck.shuffle()
	
