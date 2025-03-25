class_name Bullet
extends CharacterBody2D

@onready var player_hitbox:Hitbox

@export var initial_speed:float = 240.0
@export var target_speed:float = 240.0
@export var acceleration:float = 0.0
@export var lifespan:float = 1.0

@export var bullet_texture:Sprite2D

var speed = initial_speed
var direction = Vector2.RIGHT

func _ready() -> void:
	if player_hitbox:
		player_hitbox.area_entered.connect(_on_hitbox_area_entered)
	direction = Vector2.RIGHT.rotated(global_rotation)
	await get_tree().create_timer(lifespan).timeout
	_before_lifespan_expired()
	queue_free()


func _physics_process(delta: float) -> void:
	speed = lerp (speed, target_speed, acceleration * delta)
	velocity = direction * speed * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
	
func _before_lifespan_expired() -> void:
	pass

func _on_hitbox_area_entered(area: Area2D) -> void:
	pass
