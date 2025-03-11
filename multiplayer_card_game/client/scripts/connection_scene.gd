extends Control


@onready var label: Label = $VBoxContainer/Label
@onready var username: LineEdit = $VBoxContainer/HBoxContainer/username
@onready var host: Button = $VBoxContainer/HBoxContainer/host
@onready var join: Button = $VBoxContainer/HBoxContainer/join
@onready var start: Button = $VBoxContainer/start
@onready var start_game: Label = $VBoxContainer/start_game


@export_enum("127.0.0.1", "167.235.137.248") var Address: String = "127.0.0.1"
#@export var Address = "127.0.0.1"
#@export var Address = "167.235.137.248"
@export var port: int = 8910

var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		Address = "167.235.137.248"
		hostGame()
	
	if "host" in OS.get_cmdline_args():
		username.text = "salbih"
		_on_host_pressed()
	elif "client" in OS.get_cmdline_args():
		await get_tree().create_timer(0.1).timeout
		username.text = "jakey"
		_on_join_pressed()
		await get_tree().create_timer(0.1).timeout
		StartGame.rpc()
	#SendPlayerInformation("salbih", multiplayer.get_unique_id())
	#multiplayer.set_multiplayer_peer(peer)
	#StartGame()

# Called on Server and Clients
func peer_connected(id):
	print("Player Connected ", str(id))
	GameManager.Players.erase(id)
	
	
# Called on Server and Clients
func peer_disconnected(id):
	print("Player Disconnected ", str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("players")
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
	# var scene = load("res://client/scenes/chat_box.tscn").instantiate()
	var scene = load("res://client/scenes/client.tscn").instantiate()
	get_tree().root.add_child.call_deferred(scene)


	self.hide()
	queue_free()
	
	
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 8)
	if error != OK:
		print("cannot host: " + str(error))
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

func host_testing():
	hostGame()
	SendPlayerInformation("salbih", multiplayer.get_unique_id())
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for PLayers...")
	label.text = "Waiting for Players"
	host.hide()
	join.hide()
	username.hide()
	start.show()
	SendPlayerInformation("salbih", multiplayer.get_unique_id())

func client_testing():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	label.text = "Waiting for host to start"
	host.hide()
	join.hide()
	start.show()
	username.hide()
