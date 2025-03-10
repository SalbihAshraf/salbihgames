extends CanvasLayer

@export var slot_scene:PackedScene

@onready var gridcontainer:GridContainer = %GridContainer

func _on_button_pressed() -> void:
	$AnimationPlayer.play("trans_out")
	get_tree().paused = false
	
func display(upgrade_selection) -> void:
	for upgrade in upgrade_selection:
		var slot = slot_scene.instantiate()
		slot.setup(upgrade)
		gridcontainer.add_child(slot)
	pass
