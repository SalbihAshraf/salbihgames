extends CharacterBody2D

@export var speed : int
@export var health : int
@export var damage : int

@onready var player = get_node("/root/main/player")
@onready var main = get_node("/root/main")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var alive : bool


var dir : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alive = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if health <= 0:
		alive = false
		die()
	
	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	
	
	velocity = dir * speed
	if abs(velocity) > Vector2.ZERO:
		$AnimatedSprite2D.play("run")
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	move_and_slide()

func make_path():
	nav_agent.target_position = player.global_position
	
func die():
	
	player.player_money += 70
	queue_free()

func hit(damage):
	player.player_money += 10
	health -= damage
	$AnimatedSprite2D/AnimationPlayer.play("hit_flash")


func _on_timer_timeout() -> void:
	make_path()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	pass # Replace with function body.
