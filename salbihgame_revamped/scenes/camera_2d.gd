extends Camera2D

const 	MAX_DISTANCE = 32

var target_distance = 0
var center_pos = position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		var direction = center_pos.direction_to(get_local_mouse_position())
		target_distance = center_pos.distance_to(get_local_mouse_position()) /2
		var target_pos = center_pos + direction * target_distance
		
		target_pos = target_pos.clamp(
			center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
			center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
		)
		position = target_pos
	else: 
		position = $"../AnimatedSprite2D".position
	
