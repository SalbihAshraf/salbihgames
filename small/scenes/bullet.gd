extends Area2D

@onready var player = get_node("/root/main/player")
var speed = 200
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = player.bullet_speed
	position += speed * direction * delta
	
	pass


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	if body.name == "world":
		queue_free()
	else:
		if body.alive:
			body.die()
			queue_free()
	pass # Replace with function body.
