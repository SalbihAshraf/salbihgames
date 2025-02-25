extends Node2D

@export var player_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GameManager.Players:
		var current_player = player_scene.instantiate()
		current_player.name = str(GameManager.Players[i].id)
		current_player.id = GameManager.Players[i].id
		current_player.player_name = GameManager.Players[i].name
		add_child(current_player)
	
	for i in get_tree().get_nodes_in_group("player"):
		if i.name == str(multiplayer.get_unique_id()):
			for n in range(7):
				rpc_id(multiplayer.get_unique_id(), "game_draw()", i)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer", "call_local")
func game_draw(player):
	player.draw_card()


func _on_draw_gap_timeout() -> void:
	
	pass # Replace with function body.
