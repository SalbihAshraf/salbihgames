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
	
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
