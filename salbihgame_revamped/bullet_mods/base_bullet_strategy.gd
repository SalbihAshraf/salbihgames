class_name BaseBulletStrategy
extends Resource

###########################################
# Strategy Relevant Code:
# This is the base strategy that all other
# bullet strategies will inherit from.
###########################################


@export var texture : Texture2D = preload("res://assets/pierce_item.png")
@export var upgrade_text : String = "Pierce"
@export var price : int = 100


# This is the function that we later call when firing our bullet.
# Since we pass in the instance of the bullet, we can do anything
# to it that we could any other kind of node, plus more.
# Some examples include:
# 1. Editing simple variables (ex. bullet.damage += 5)
# 2. Calling any functions defined in the node
# 3. Attaching components or changing properties of any attached component
func apply_bullet_upgrade(bullet):
	# This does nothing by default
	pass

func apply_player_upgrade(player):
	pass
	
func apply_nothing(bullet):
	pass
