extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var momentum = 1
var moving = false

@onready var nav: NavigationAgent2D =  $NavigationAgent2D

@export var pathfinding = false

signal gun_shot(pos, direction)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", 'right', 'up', 'down')
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	if pathfinding:
		nav.target_position = get_global_mouse_position()
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	velocity = direction * 500 * momentum
	if direction != Vector2(0,0):
		moving = true
	else:
		moving = false
	
	if player_direction.x > -0.8 and player_direction.x < 0.8 and player_direction.y > 0:
		# looking down
		if moving:
			pass
		else:
			$idle/idle_animation.play("idle_down")
		$idle/pistol.show_behind_parent = false
	elif player_direction.x > -0.8 and player_direction.x < 0.8 and player_direction.y < 0:
		# looking up
		if moving:
			pass
		else:
			$idle/idle_animation.play("idle_up")
		$idle/pistol.show_behind_parent = true
	elif player_direction.y > -0.7 and player_direction.y < 0.7 and player_direction.x < 0:
		# looking left
		if moving:
			pass
		else:
			$idle/idle_animation.play("idle_right")
		$idle.scale = Vector2(-1,1)
		$idle/pistol.show_behind_parent = true
	elif player_direction.y > -0.7 and player_direction.y < 0.7 and player_direction.x > 0:
		# looking right
		if moving:
			pass
		else:
			$idle/idle_animation.play("idle_right")
		$idle.scale = Vector2(1,1)
		$idle/pistol.show_behind_parent = true
	else:
		$idle.frame = 0
	
	if Input.is_action_just_pressed("primary"):
		var bullet_pos = $idle/pistol/Marker2D.global_position
		gun_shot.emit(bullet_pos, player_direction)
		
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	move_and_slide()
	
	$idle/pistol.look_at(get_global_mouse_position())
