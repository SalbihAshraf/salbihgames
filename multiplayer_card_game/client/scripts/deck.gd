class_name Deck
extends Control

@onready var label: Label = %Label

var deck_contents = []
		
# Called when he node enters the scene tree for the first time.
func _ready() -> void:
	for i in GameManager.suits:
		for j in GameManager.ranks:
			deck_contents.append([i,j])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	label.text = str(deck_contents.size())
	pass


func _on_texture_button_pressed() -> void:
	for i in get_tree().get_nodes_in_group("players"):
		if multiplayer.get_unique_id() == i.id:
			i.draw_card()
	pass # Replace with function body.

func _on_control_mouse_entered() -> void:
	print(deck_contents)
	pass # Replace with function body.
