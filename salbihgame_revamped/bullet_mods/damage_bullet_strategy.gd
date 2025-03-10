class_name DamageBulletStrategy
extends BaseBulletStrategy


func apply_bullet_upgrade(bullet):
	bullet.damage += 1
	bullet.damage_sprite = true
	bullet.modulate = Color(0.7, 0.5, 0.5, 1)
