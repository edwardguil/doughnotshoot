extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1989;
var max_players = 100;

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
	if get_node("Queue").IsInQueue(player_id):
		get_node("Queue").RemoveFromQueue(player_id)

remote func JoinQueue():
	var player_id = get_tree().get_rpc_sender_id()
	if !get_node("Queue").IsInQueue(player_id):
		get_node("Queue").AddPlayer(player_id)
