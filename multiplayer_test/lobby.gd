extends Node2D

@onready var host: Button = $Host
@onready var join: Button = $Join
@onready var start: Button = $Start
@onready var username: LineEdit = $Username
@onready var label: Label = $Label


#@export var Address = "127.0.0.1"
@export var Address = "167.235.137.248"
@export var port = 8910

var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.

# Called on Server and Clients
func peer_connected(id):
	print("Player Connected ", str(id))
	GameManager.Players.erase(id)
	
	
# Called on Server and Clients
func peer_disconnected(id):
	print("Player Disconnected ", str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

# Called on Clients only
func connected_to_server():
	print("Connected to Server!")
	SendPlayerInformation.rpc_id(1, username.text, multiplayer.get_unique_id())

# Called on Clients only
func connection_failed():
	print("Couldnt Connect")
	
@rpc("any_peer")
func SendPlayerInformation(usrname, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : usrname,
			"id" : id,
			"score" : 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@rpc("any_peer", "call_local")
func StartGame():
	# ///NEED MAIN SCENE TO LOAD///
	# var scene = load("res://game.tscn").instantiate()
	var scene = load("res://chat.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 16)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for PLayers...")
	label.text = "Waiting for Players"
	host.hide()
	join.hide()
	username.hide()
	start.show()
	
	
func _on_host_pressed() -> void:
	hostGame()
	SendPlayerInformation(username.text, multiplayer.get_unique_id())
	pass # Replace with function body.
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for PLayers...")
	label.text = "Waiting for Players"
	host.hide()
	join.hide()
	username.hide()
	start.show()
	SendPlayerInformation(username.text, multiplayer.get_unique_id())
	pass # Replace with function body.

func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	label.text = "Waiting for host to start"
	host.hide()
	join.hide()
	start.show()
	username.hide()
	pass # Replace with function body.

func _on_start_pressed() -> void:
	StartGame.rpc()
	pass # Replace with function body.
