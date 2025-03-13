extends Control

signal suit_signal
signal rank_signal
signal shuffle_signal
signal play_card_signal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_suit_button_pressed() -> void:
	print("hello")
	Ui.emit_signal("suit_signal")

func _on_rank_button_pressed() -> void:
	Ui.emit_signal("rank_signal")

func _on_shuffle_button_pressed() -> void:
	Ui.emit_signal("shuffle_signal")
	
func _on_play_button_pressed() -> void:
	Ui.emit_signal("play_card_signal")
