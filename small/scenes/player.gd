extends CharacterBody2D

@onready var main = get_node("/root/main")
const START_SPEED : int = 200
const BOOST_SPEED : int = 350
var bullet_speed : int = 500
var speed : int
var screen_size : Vector2
var can_shoot : bool
var invul : bool
signal shoot

func _ready():
	screen_size = get_viewport_rect().size
	speed = START_SPEED
	can_shoot = true

func reset():
	invul = false
	position = screen_size / 2
	speed = START_SPEED
	can_shoot = true
	
func get_input():
	#keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$Timer.start()
	
	pass

func _physics_process(_delta):
	
	
	
	#player movement
	get_input()
	move_and_slide()
	
	#limit movement to the window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	#animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
	
	pass


func boost():
	$boost_timer.start()
	speed = BOOST_SPEED

func _on_boost_timer_timeout():
	speed = START_SPEED
	pass # Replace with function body.


func gun_boost():
	$gun_timer.start()
	bullet_speed = 800
	$Timer.wait_time = 0.2
	

func _on_gun_timer_timeout():
	bullet_speed = 500
	$Timer.wait_time = 0.3
	pass # Replace with function body.
	
func bubble_boost():
	$AnimatedSprite2D/AnimationPlayer.play("invul")
	invul = true
	$invul_timer.start()
	
func _on_timer_timeout():
	can_shoot = true
	pass # Replace with function body.

func _on_invul_timer_timeout():
	invul = false
	pass # Replace with function body.
