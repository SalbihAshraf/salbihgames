extends CharacterBody2D

@onready var player = get_node("/root/main/player")
@onready var main = get_node("/root/main")

var item_scene := preload("res://scenes/item.tscn")
var explosion_scene := preload("res://scenes/explosion.tscn")

var entered : bool
var speed : int
var direction : Vector2
var alive : bool

signal hit_player

func _ready():
	name = "goblin"
	alive = true
	var screen_rect = get_viewport_rect()
	entered = false
	
	#pick direction for goblin
	var dist = screen_rect.get_center() - position
	if abs(dist.x) > abs(dist.y):
		#move horizontally
		direction.x = dist.x
		direction.y = 0
	else:
		#move vertically
		direction.y = dist.y
		direction.x = 0
		
		pass
	
	pass


func _physics_process(delta):
	
	if alive:
		$AnimatedSprite2D.animation = "run"
		
		if entered:
			direction = (player.position - position)
		direction = direction.normalized()
		speed = 90 + (main.wave * 10)
		
		if speed > 200:
			speed = 200
			
		velocity = direction * speed
		move_and_slide()
		
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass


func die():
	alive = false
	
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$AnimatedSprite2D/AnimationPlayer.play("fade_out")
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$deathtimer.start()
	
	main.max_enemies -= 1
	drop_item()
	
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS

func drop_item():
	if randi_range(0, 2) == 1:
		
		var item = item_scene.instantiate()
		item.position = position
		item.item_type = randi_range(0, 3)
		main.call_deferred("add_child", item)
		item.add_to_group("item")

func _on_entrancetimer_timeout():
	entered = true
	pass # Replace with function body.




func _on_area_2d_body_entered(_body):
	hit_player.emit()
	pass # Replace with function body.


func _on_deathtimer_timeout():
	queue_free()
	pass # Replace with function body.
