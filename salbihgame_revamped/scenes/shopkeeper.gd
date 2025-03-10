extends StaticBody2D

@export var upgrade_scene : PackedScene

@onready var player = get_node("/root/main/player")

var in_range : bool = false
@onready var shop_interface: CanvasLayer = $Area2D/shop_interface

var upgrade_list : Array = [
	"res://resources/bullet_mod_resources/damage.tres",
	"res://resources/bullet_mod_resources/pierce.tres",
	"res://resources/bullet_mod_resources/speed.tres",
	"res://resources/player_mod_resources/player_reload.tres",
	"res://resources/player_mod_resources/player_speed.tres"
]

var upgrade_selection : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_upgrade_dict()
	shop_interface.hide()
	$cash_bubble.hide()
	$cash_bubble.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body) -> void:
	print("hi " + body.name + " want to shop?")
	$cash_bubble.show()
	$cash_bubble.play("default")
	in_range = true
	
	pass # Replace with function body.

func _on_area_2d_body_exited(body: Node2D) -> void:
	$cash_bubble.hide()
	in_range = false
	
	pass # Replace with function body.


func _on_player_interact(player) -> void:
	
	if in_range:
		
		get_tree().paused = true
		shop_interface.show()
		shop_interface.display(upgrade_selection)
		get_node("Area2D/shop_interface/AnimationPlayer").play("trans_in")
		get_node("Area2D/shop_interface/Panel/Label").text = "POINTS: \n" + str(player.player_money)
	pass # Replace with function body.

func create_upgrade_dict():
	for x in upgrade_list:
		var upgrade = upgrade_scene.instantiate()
		upgrade.bullet_strategy = load(x) as BaseBulletStrategy
		upgrade_selection.append(upgrade)
	for x in upgrade_selection:
		print(x.bullet_strategy.upgrade_text)
