extends Node2D

@export var player_scene: PackedScene
var players = []
@onready var deck: Deck = $deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GameManager.Players:
		var current_player = player_scene.instantiate()
		current_player.name = str(GameManager.Players[i].id)
		current_player.id = GameManager.Players[i].id
		current_player.player_name = GameManager.Players[i].name
		add_child(current_player)
		players.append(current_player)
	
	if multiplayer.is_server():
		for i in players:
			for j in range(7):
				i.draw_card.rpc(deck.deck_contents.pick_random())
			print(i.player_hand)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
