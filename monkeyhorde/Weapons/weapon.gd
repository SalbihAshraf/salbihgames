class_name Weapon
extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var bullet_scene:PackedScene

@export var fire_rate:float = 4
@export var spread:float = 2
@export var reload_timer:float = 1.0
@export var shots:int = 1

var can_fire:bool = true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func fire(pos, dir):
	if can_fire:
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		var random_spread = randf_range(-spread, spread)
		bullet.direction = dir.normalized() 
		bullet.rotation = dir.angle()
		bullet.position = pos
		
		get_tree().create_timer(1 / fire_rate).timeout.connect(_on_fire_rate_timeout)
		can_fire = false
	pass

func _on_fire_rate_timeout():
	can_fire = true
