extends Node2D


@export var card_texture: Texture2D

signal hovered
signal hovered_off

var hand_position

var suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CardImage.texture = card_texture
	
	var card_suit = suits.pick_random()
	var rank = ranks.pick_random()
	%CardImage.texture = load("res://Playing Cards Pixelart Asset Pack/Sprites/" + card_suit + " " + str(rank) + ".png")
	$AnimationPlayer.play("idle")
	$AnimationPlayer.speed_scale = randf_range(0.5, 1)
	%CardImage.rotation = randf_range(0.07, -0.07)
	
	# All cards must be a child of CardManager or this will error
	get_parent().connect_card_signals(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stop_animation():
	%CardImage.rotation = 0
	$AnimationPlayer.play("paused")
	
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
