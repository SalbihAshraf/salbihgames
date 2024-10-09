extends Area2D

@export var speed:int = 1000
@export var dmg = 1
var direction:Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	body.hit()
	queue_free()
	pass # Replace with function body.
