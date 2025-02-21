extends Node2D

@onready var messages: TextEdit = $VBoxContainer/messages
@onready var send: Button = $VBoxContainer/HBoxContainer/send
@onready var message: LineEdit = $VBoxContainer/HBoxContainer/message
@onready var text_edit: TextEdit = $TextEdit
@onready var id = multiplayer.get_unique_id()
var username: String
var msg: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in GameManager.Players:
		messages.text += "Player has connected: " + GameManager.Players[i].name + "\n"
		if GameManager.Players[i].id == id:
			username = GameManager.Players[i].name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		if message.text != "" :
			msg_rpc.rpc(username, message.text)
			#rpc("msg_rpc", username, message.text)
			message.text = ""
			
	if event.is_action_pressed("tab"):
		text_edit.show()
		text_edit.text += "Players in chat room \n"
		for i in GameManager.Players:
			text_edit.text += str(GameManager.Players[i].id) + ": " + str(GameManager.Players[i].name) + "\n"
	if event.is_action_released("tab"):
		text_edit.text = ""
		text_edit.hide()
		
func _on_send_pressed() -> void:
	if message.text != "" :
		rpc("msg_rpc", username, message.text)
		message.text = ""
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func msg_rpc(sender, data):
	if sender == username:
		messages.text += str(sender + " (You): ", data, "\n")
	else:
		messages.text += str(sender + ": ", data, "\n")
	messages.scroll_vertical = INF
