class_name SpeedBulletStrategy
extends BaseBulletStrategy

var particle_scene : PackedScene = preload("res://scenes/bullet_particles.tscn")

func apply_bullet_upgrade(bullet):
	bullet.speed += 100
	
	var spawned_particles : Node2D = particle_scene.instantiate()
	bullet.add_child(spawned_particles)
	spawned_particles.global_position = bullet.global_position
