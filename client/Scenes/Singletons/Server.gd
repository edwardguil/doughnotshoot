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
	
remote func SetQueueStatus(status):
	#instance_from_id(requester).SetQueueStatus(success)
	get_node("/root/Menu").SetQueueStatus(status)
	
remote func SpawnNewPlayers(players, positions):
	GameController.SpawnPlayers(players, positions)

remote func DespawnPlayer(player_id):
	GameController.DespawnPlayers(player_id)

func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)

remote func RecieveWorldState(world_state):
	GameController.UpdateWorldState(world_state)
