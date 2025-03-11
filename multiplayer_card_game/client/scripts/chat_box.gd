extends Control


@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var unread_messages_number: Label = $HBoxContainer/unread_messages
var unread_messages: int = 0:
	set(val):
		if val == 0:
			unread_messages_number.hide()
		else:
			unread_messages = val
			unread_messages_number.show()
			unread_messages_number.text = str(unread_messages)


@onready var messages: TextEdit = $VBoxContainer/messages
@onready var send: Button = $VBoxContainer/HBoxContainer/send
@onready var message: LineEdit = $VBoxContainer/HBoxContainer/message
@onready var text_edit: TextEdit = $TextEdit
@onready var id: int = multiplayer.get_unique_id()
var username: String
var msg: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in GameManager.Players:
		messages.text += "Player has connected: " + GameManager.Players[i].name + "\n"
		if GameManager.Players[i].id == id:
			username = GameManager.Players[i].name

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

@rpc("any_peer", "call_local")
func msg_rpc(sender, data):
	if sender == username:
		messages.text += str(sender + " (You): ", data, "\n")
	else:
		messages.text += str(sender + ": ", data, "\n")
		if not v_box_container.visible:
			unread_messages += 1

		
	messages.scroll_vertical = messages.get_line_count()

func _on_button_pressed() -> void:
	if v_box_container.visible:
		v_box_container.hide()
	else:
		v_box_container.show()
		unread_messages = 0
