extends Node

var Players = {}
var suits:Array[String] = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks:Array[int] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var ranks_reversed:Array[int] = [13,12,11,10,9,8,7,6,5,4,3,2,1]
# var ranks: Array[String] = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
var player_objects: Array[Player] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
