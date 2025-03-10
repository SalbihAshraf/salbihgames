extends CharacterBody2D

@export var speed : int
@export var bullet_speed : int
@export var max_mag : int
@export var health : int = 2

var player_money : int = 0

#various gui elements and timers for player
@onready var ammo_label: Label = $AnimatedSprite2D/ammo_label
@onready var money_label
@onready var reload_bar: ProgressBar = $AnimatedSprite2D/reload_bar
@onready var display_timer: Timer = $AnimatedSprite2D/ammo_label/display_timer

@onready var hit_timer: Timer = $hit_timer
@onready var invul_timer: Timer = $invul_timer
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer



var can_shoot : bool = true
var reloading : bool = false
var reload_wait : float = 1
var invul : bool = false

var upgrades : Array[BaseBulletStrategy] = []

var mag : int

signal shoot
signal interact

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_bar.max_value = reload_wait
	reload_bar.hide()
	mag = max_mag

func get_input():
	#keyboard input to move player
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	#mouse left click input to fire bullet
	if Input.is_action_pressed("fire") and can_shoot and !reloading:
		
		#show ammo label and start timer to slowly disssapear label till next shot
		display_timer.start()
		ammo_label.show()
		
		#reduce current ammo by 1
		#if ammo == 0, then reload
		mag -= 1
		if mag <= 0:
			reload()
			
		#get position of mouse to send bullet in that direction then emit shoot to create bullet
		#send to (bullet_manager.tscn)
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		
		#cannot shoot until shot timer runs out
		can_shoot = false
		$shot_timer.start()
		
	#manual reload using "R" button
	if Input.is_action_just_pressed("reload") and !reloading:
		reload()
	
	if Input.is_action_just_pressed("interact"):
		interact.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		
	if reloading:
		reload_bar.value = $reload_timer.time_left
		reload_bar.max_value = reload_wait 
		
	ammo_label.text = str(mag)
	ammo_label.modulate.a = (display_timer.time_left / 3)
	
	#player movement
	get_input()
	move_and_slide()
	
	#rotation
	
	#rotation via controller
	#var mouse = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
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
	


func _on_shot_timer_timeout() -> void:
	
	can_shoot = true
	pass # Replace with function body.

func add_upgrades():
	print("adding upgrade")
	player_stats_reset()
	for strategy in upgrades:
		if strategy.has_method("apply_player_upgrade"):
			strategy.apply_player_upgrade(self)
	print(speed)

func _on_reload_timer_timeout() -> void:
	reload_bar.hide()
	ammo_label.show()
	reloading = false
	mag = 10
	pass # Replace with function body.

func player_stats_reset():
	speed = 80
	reload_wait = 1



func reload():
	reload_bar.show()
	ammo_label.hide()
	$reload_timer.wait_time = reload_wait
	mag = 0
	reloading = true
	$reload_timer.start()


func _on_display_timer_timeout() -> void:
	ammo_label.hide()
	pass # Replace with function body.

func take_damage(damage_amount):
	if !invul:
		health -= damage_amount
		if health == 1:
			hit_timer.start()
			invul_timer.start()
			animation_player.play("damaged")
			invul = true
		if health == 0:
			get_tree().paused = true
			
	else:
		pass


func _on_invul_timer_timeout() -> void:
	invul = false
	pass # Replace with function body.


func _on_hit_timer_timeout() -> void:
	animation_player.play("RESET")
	health = 2
	pass # Replace with function body.
