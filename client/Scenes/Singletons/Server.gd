extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1989
var client_clock = 0
var decimal_collector : float = 0
var latency_array = []
var latency = 0
var delta_latency = 0

func _ready():
	ConnectToServer()
	
func _physics_process(delta):
	client_clock += int(delta*1000) + delta_latency
	delta_latency -= delta_latency
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00
		
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

remote func ReturnServerTime(server_time, client_time):
	latency = (OS.get_system_time_msecs() - client_time) / 2
	client_clock = server_time + latency

func DetermineLatency():
	rpc_id(1, "DetermineLatency", OS.get_system_time_msecs())

remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size()-1, -1, -1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()
		
func FetchJoinQueue():
	rpc_id(1, "JoinQueue")

func _OnConnectedFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Sucessfully connected")
	rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)
	
func JoinQueue():
	rpc_id(1, "JoinQueue")
	
remote func SetQueueStatus(status):
	#instance_from_id(requester).SetQueueStatus(success)
	print("Set QueStatus Called")
	if get_tree().current_scene.has_method("SetQueueStatus"):
		get_tree().current_scene.SetQueueStatus(status)
	
remote func SpawnNewPlayers(players, positions):
	print("Spawn Players Called")
	GameController.SpawnPlayers(players, positions)

remote func DespawnPlayer(player_id):
	print("Despawn Players Called")
	GameController.DespawnPlayers(player_id)

func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)

remote func RecieveWorldState(world_state):
	GameController.UpdateWorldState(world_state)
