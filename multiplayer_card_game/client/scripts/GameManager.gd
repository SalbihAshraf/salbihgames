extends Node

var Players = {}
var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
var current_player: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func send_information(message):
	var client = get_tree().root.get_node("/root/client")
	client.label.text = message
	pass

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
