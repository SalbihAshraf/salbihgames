class_name Card
extends Node2D

@onready var card_face_texture: Sprite2D = $card_face_texture
@onready var card_back_texture: Sprite2D = $card_back_texture

signal hovered
signal hovered_off

var suit = "Hearts"
var rank = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_texture()

func set_texture():
	if suit == "Hearts":
		card_face_texture.frame_coords.y = 0
	elif suit == "Diamonds":
		card_face_texture.frame_coords.y = 1
	elif suit == "Spades":
		card_face_texture.frame_coords.y = 2
	elif suit == "Clubs":
		card_face_texture.frame_coords.y = 3
	
	card_face_texture.frame_coords.x = str(rank).to_int() - 1

func _input(event: InputEvent) -> void:
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_control_mouse_entered() -> void:
	hover_animation()


func _on_control_mouse_exited() -> void:
	un_hover_animation()

func hover_animation():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(card_face_texture, "scale", Vector2(1.25,1.25), 0.1)

func un_hover_animation():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(card_face_texture, "scale", Vector2(1,1), 0.1)
