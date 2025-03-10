class_name PierceBulletStrategy
extends BaseBulletStrategy


func apply_bullet_upgrade(bullet):
	bullet.max_pierce += 2
	bullet.animation.play("pierce")

func apply_nothing(bullet):
	print("kazzoo")
