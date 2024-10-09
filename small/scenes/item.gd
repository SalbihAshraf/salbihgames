extends Area2D

@onready var main = get_node("/root/main")
var item_type : int # 0:coffee, 1: health, 2: gun

var coffee_item = preload("res://assets/coffee_item.png")
var heart_item = preload("res://assets/heart_item.png")
var gun_item = preload("res://assets/gun_item.png")
var bubble_item = preload("res://assets/bubble_item.png")
var textures = [coffee_item, heart_item, gun_item, bubble_item]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]
	$despawntimer.start()
	$Sprite2D/AnimationPlayer.play("flash")
	pass # Replace with function body.




func _on_body_entered(body):
	
	if item_type == 0:
		body.boost()
		
	elif item_type == 1:
		main.lives += 1
		
	elif item_type == 2:
		body.gun_boost()
		
	elif item_type == 3:
		body.bubble_boost()
	
	queue_free()
	pass # Replace with function body.


func _on_despawntimer_timeout():
	queue_free()
	pass # Replace with function body.
