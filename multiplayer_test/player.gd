extends Node2D

var id : int
var player_name : String
var score : int
@onready var start_timer: Timer = $start_timer
@onready var deck_reference = $"../deck"
@onready var player_hand_node: Node2D = $player_hand
var index: int = 100

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(str(name).to_int())
	start_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_up") and multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		player_hand_node.draw_card()
	if event is InputEventKey and event.is_action_pressed("ui_down") and multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		print(player_name)
		print("\n player_hand:")
		print(player_hand_node.player_hand)
		print("\n deck:")
		print(deck_reference.deck)

func _on_start_timer_timeout() -> void:
	pass # Replace with function body.



	

@rpc("any_peer", "call_local")
func remove_from_deck(card_to_remove):
	deck_reference.deck.erase(card_to_remove)
	
