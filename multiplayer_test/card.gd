extends Node2D

var suit = "Spades"
var rank = 11
@onready var sprite_2d: Sprite2D = $Sprite2D
# CARD STATES
var hovered : bool = false
var clicked : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_texture()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if hovered:
			clicked = !clicked
			if !clicked:
				#check_highest_z_index()
				clicked_animation()
			else:
				unclicked_animation()
			print([suit, rank])
		

func set_texture():
	if suit == "Hearts":
		sprite_2d.frame_coords.y = 0
	elif suit == "Diamonds":
		sprite_2d.frame_coords.y = 1
	elif suit == "Spades":
		sprite_2d.frame_coords.y = 2
	elif suit == "Clubs":
		sprite_2d.frame_coords.y = 3
	
	sprite_2d.frame_coords.x = str(rank).to_int() - 1
	pass


func _on_area_2d_mouse_entered() -> void:
	hovered = true
	if !clicked:
		hover_animation()
	pass # Replace with function body.

func hover_animation():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(sprite_2d, "scale", Vector2(2.5,2.5), 0.1)

func _on_area_2d_mouse_exited() -> void:
	hovered = false
	if !clicked:
		un_hover_animation()
	pass # Replace with function body.

func un_hover_animation():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(sprite_2d, "scale", Vector2(2,2), 0.1)

func clicked_animation():
	var tween = get_tree().create_tween()
	var previous_pos = sprite_2d.position.y
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(sprite_2d, "position:y", (previous_pos + 50), 0.1)
	pass

func unclicked_animation():
	var tween = get_tree().create_tween()
	var previous_pos = sprite_2d.position.y
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(sprite_2d, "position:y", (previous_pos - 50), 0.1)
