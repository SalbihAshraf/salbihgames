extends Node2D

@export var bullet_scene : PackedScene

var multi_shot : bool = false

func _on_player_shoot(pos, dir):
	
	if multi_shot:
		shoot_three(pos, dir)
	else:
		shoot_one(pos, dir)
	
	
	pass # Replace with function body.

func shoot_one(pos, dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.direction = dir.normalized()
	bullet.rotation = dir.angle()
	bullet.position = pos + (bullet.direction * 5)
	bullet.add_to_group("bullets")

func shoot_three(pos, dir):
		
	var bullet1 = bullet_scene.instantiate()
	var bullet2 = bullet_scene.instantiate()
	var bullet3 = bullet_scene.instantiate()
	
	add_child(bullet1)
	add_child(bullet2)
	add_child(bullet3)

	
	
	
	bullet1.direction = dir.normalized() * Vector2(1,0)
	bullet2.direction = dir.normalized()
	bullet3.direction = dir.normalized() / Vector2(1,0)
	
	bullet1.rotation = dir.angle() + 3
	bullet2.rotation = dir.angle()
	bullet3.rotation = dir.angle() - 3
	
	bullet1.position = pos + (bullet1.direction * 5)
	bullet2.position = pos + (bullet2.direction * 5)
	bullet3.position = pos + (bullet3.direction * 5)
	
	bullet1.add_to_group("bullets")
	bullet2.add_to_group("bullets")
	bullet3.add_to_group("bullets")
