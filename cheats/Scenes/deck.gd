extends Node2D

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var deck = []

@onready
var card_scene = preload("res://Scenes/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in suits:
		for j in ranks:
			deck.append([i,j])
			
	print(deck)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(len(deck))
	pass
