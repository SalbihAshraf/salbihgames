class_name Deck
extends Node2D

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var deck_contents = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in suits:
		for j in ranks:
			deck_contents.append([i,j])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
