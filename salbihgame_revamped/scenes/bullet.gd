extends Area2D

@onready var player = get_node("/root/main/player")
@onready var bullet_manager = get_node("/root/main/bullet_manager")

@export var speed : int
@export var damage : int
@export var max_pierce : int

var multi_shot = false
var damage_sprite : bool = false
var direction : Vector2
var current_pierce : int = 0
@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_manager.multi_shot = false
	animation.play("default")
	
	
	
	
	$bullet_lifetime.start()
	
	for strategy in player.upgrades:
		if strategy.has_method("apply_bullet_upgrade"):
			strategy.apply_bullet_upgrade(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * direction * delta
	
	pass

func _on_bullet_lifetime_timeout() -> void:
	queue_free()
	pass # Replace with function body.

func _on_body_entered(body):
	if (body.name == "hills_layer" or body.name == "deco_layer" or body.name == "shopkeeper"):
		queue_free()
	else:
		if body.alive == true:
			body.hit(damage)
			current_pierce += 1
			if current_pierce >= max_pierce:
				queue_free()
