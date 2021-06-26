extends Node
var peer = NetworkedMultiplayerENet.new()
onready var SERVER_IP = "127.0.0.1"
onready var SERVER_PORT = 1909
onready var MAX_PLAYERS = 8


func create_server(SERVER_PORT):
	
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	print("servidor iniciado")
	
	peer.connect("peer_connected", self, "_Peer_Connected")
	peer.connect("peer_disconnected", self, "_Peer_Disconnected")



func create_client(SERVER_IP, SERVER_PORT):
	
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	peer.connect("connection_failed", self, "_OnConnectionFailed")
	peer.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	peer.connect("server_disconnected" , self, "_OnServerDisconnected")
