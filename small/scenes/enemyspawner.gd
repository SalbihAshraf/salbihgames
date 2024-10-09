extends Node2D

@onready var main = get_node("/root/main")

var goblin_scene := preload("res://scenes/goblin.tscn")
var spawn_points := []

signal hit_p

func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	pass
func _process(_delta):
	$Timer.wait_time = 1 - (main.wave * 0.1)
	pass

func _on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		
		#pick random spawnpoint
		var spawn = spawn_points[randi() % spawn_points.size()]
		
		var goblin = goblin_scene.instantiate()
		
		goblin.position = spawn.position
		goblin.hit_player.connect(hit)
		main.add_child(goblin)
		goblin.add_to_group("enemies")
		
	pass # Replace with function body.
	
func hit():
	hit_p.emit()
	pass
