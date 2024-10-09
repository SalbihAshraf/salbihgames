extends Node2D

var max_enemies : int
var wave : int
var lives : int

@onready var player = get_node("/root/main/player")

func _ready():
	new_game()
	
	
	$game_over/Button.pressed.connect(new_game)
	$win/Button.pressed.connect(new_game)
	
	
func new_game():
	wave = 1
	lives = 3
	max_enemies = 20
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("item", "queue_free")
	$player.reset()
	
	$win.hide()
	$game_over.hide()
	$newwave.hide()
	get_tree().paused = false
	
func _process(_delta):
		
	
	$hud/lives.text = "x " + str(lives)
	$hud/waves.text = "Wave " + str(wave)
	$hud/goblins.text = "x " + str(max_enemies)
	if max_enemies <= 0:
		$newwave.show()
		$newwavetimer.start()
		get_tree().paused = true
	
	if lives <= 0:
		$hud/lives.text = "x 0"
		$game_over.show()
		get_tree().paused = true
		
#		$game_over.show()
#		
	
	pass
	
func _on_enemyspawner_hit_p():
	if !player.invul:
		lives -= 1
		$player/AnimatedSprite2D/AnimationPlayer.play("flash")
	
func new_wave():
	wave += 1
	max_enemies = 10 + (10  * wave)
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("item", "queue_free")
	
	$newwave.hide()
	get_tree().paused = false
	pass


func _on_newwavetimer_timeout():
	new_wave()
	pass # Replace with function body.
