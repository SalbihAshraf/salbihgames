extends Node2D

@onready var player = $player
var goblin_scene := preload("res://scenes/goblin.tscn")
var spawned_goblins : int = 0
var max_enemies : int = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		spawn_goblin()
	pass

func spawn_goblin():
	var goblin = goblin_scene.instantiate()
	goblin.position = Vector2(336,248)
	add_child(goblin)
	spawned_goblins += 1


func _on_panel_timer_timeout() -> void:
	$Panel.hide()
	pass # Replace with function body.
