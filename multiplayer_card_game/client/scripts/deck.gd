class_name Deck
extends Node2D


var deck_contents = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GameManager.suits:
		for j in GameManager.ranks:
			deck_contents.append([i,j])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_control_mouse_entered() -> void:
	print(deck_contents)
	pass # Replace with function body.
