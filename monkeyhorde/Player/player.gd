class_name Player
extends CharacterBody2D
var speed = 70
@export var animated_sprite: AnimatedSprite2D
var facing_direction: String = "right"
@export var weapon_scene:PackedScene
var weapon:Weapon

func _ready() -> void:
	animated_sprite.play("idle_right")
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	
func _physics_process(delta: float) -> void:
	weapon.global_position = global_position
	pick_animation()
	get_input()
	move_and_slide()


func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	if Input.is_action_pressed("fire"):
		var dir = get_global_mouse_position() - position
		weapon.fire(position, dir)

func pick_animation():
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)

	if angle == 0 or angle == 1 or angle == 7:
		animated_sprite.flip_h = false
		facing_direction = "right"
	elif angle == 2:
		facing_direction = "down"
	elif angle == 3 or angle == 4 or angle == 5:
		animated_sprite.flip_h = true
		facing_direction = "right"
	elif angle == 6:
		facing_direction = "up"
	
	if velocity:
		animated_sprite.play("run_" + facing_direction)
	else:
		animated_sprite.play("idle_" + facing_direction)
