extends Node2D

@onready var main = get_node("/root/main")
var goblin_scene := preload("res://scenes/goblin.tscn")
var wait = randi_range(3,6)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = wait
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var wait = randi_range(3, 6)
	$Timer.wait_time = wait
		

	if main.spawned_goblins <= main.max_enemies:
		$CPUParticles2D.emitting = true
		var goblin = goblin_scene.instantiate()
		goblin.position = position
		main.add_child(goblin)
		goblin.add_to_group("enemies")
		main.spawned_goblins += 1
		$Timer.start()
	pass # Replace with function body.
