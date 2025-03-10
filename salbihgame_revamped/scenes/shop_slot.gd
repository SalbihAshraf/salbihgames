extends PanelContainer

@onready var label: Label = %Label
@onready var texture_rect: TextureRect = %TextureRect
var slot_upgrade


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(upgrade):
	print(upgrade.price)
	var slot_upgrade = upgrade
	texture_rect.texture = upgrade.texture
	pass
