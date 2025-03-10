@tool
extends Area2D

@onready var player = get_node("/root/main/player")

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var price : int
@export var bullet_strategy : BaseBulletStrategy:
	set(val):
		bullet_strategy = val
		needs_update = true

# Used when editing to denote that the sprite has changed and needs updating
@export var needs_update := false


func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = bullet_strategy.texture
	upgrade_label.text = bullet_strategy.upgrade_text
	price = bullet_strategy.price


func _process(delta: float) -> void:
	
	# This is run only when we're editing the scene
	# It updates the texture of the sprite when we replace the upgrade strategy
	if Engine.is_editor_hint():
		if needs_update:
			sprite.texture = bullet_strategy.texture
			upgrade_label.text = bullet_strategy.upgrade_text
			
			needs_update = false


func on_body_entered(body):
	if body.name == "player":
		######################################
		# Strategy Relevant Code:
		# This adds the upgrade to our player,
		# which the player uses when firing.
		######################################
		
		body.upgrades.append(bullet_strategy)
		player.add_upgrades()
		queue_free()
