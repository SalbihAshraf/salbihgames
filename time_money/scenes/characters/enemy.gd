extends CharacterBody2D

@export var health = 10
var rng = RandomNumberGenerator.new()
const speed = 50

func _ready():
	$Sprite2D/AnimationPlayer.play("idle")
	$Timer.start()

func _process(delta):
	move_and_slide()
	
	if health <= 0:
		print("im dead")
		queue_free() 
	


func _on_timer_timeout():
	print("timer reached")
	var xdir = rng.randf_range(-1, 1)
	var ydir = rng.randf_range(-1, 1)
	velocity = Vector2(xdir, ydir) * speed
	$Timer2.start()
	
	pass # Replace with function body.
	
func _on_timer2_timeout():
	velocity = Vector2(0,0) * 0
	
	pass
	
	
func hit():
	var crit = 7
	crit = randf_range(0,10)
	if crit == 7:
		print("crit: ", $".")
		health -= 4
	else:
		print("hit: ", $".")
		health -= 1
	$Sprite2D/AnimationPlayer.play("flash")
	await $Sprite2D/AnimationPlayer.animation_finished
	$Sprite2D/AnimationPlayer.play("idle")
	print(health)
	pass


func _on_timer_2_timeout():
	pass # Replace with function body.
