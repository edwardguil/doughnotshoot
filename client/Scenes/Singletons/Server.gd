extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1989


func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

func _OnConnectedFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Sucessfully connected")


func JoinQueue():
	rpc_id(1, "JoinQueue")
