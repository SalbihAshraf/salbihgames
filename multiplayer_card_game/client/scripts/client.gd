class_name Client
extends Node2D

@export var player_scene: PackedScene
@onready var deck = %deck

@onready var pile: Pile = %pile


var played_card: Card

var players: Array[Player] = []
var list = [1,2,3,4,5,6,7,8]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(list.back())
	for i in GameManager.Players:
		var current_player = player_scene.instantiate()
		current_player.name = str(GameManager.Players[i].id)
		current_player.id = GameManager.Players[i].id
		current_player.player_name = GameManager.Players[i].name
		add_child(current_player)
		
	
	if multiplayer.is_server():
		await get_tree().create_timer(1).timeout
		for j in range(7):
			for i in get_tree().get_nodes_in_group("players"):
				i.draw_card()
				await get_tree().create_timer(0.05).timeout
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
