extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1989;
var max_players = 100;
var players_states = {}
var players_games = {}

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
	if (players_games.has(player_id)):
		var gameId = players_games.get(player_id)
		get_node(gameId).RemovePlayer(player_id)
		players_games.erase(player_id)
	if players_states.has(player_id):
		players_states.erase(player_id)

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(), client_time)

remote func DetermineLatency(client_time):	
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)

remote func RecievePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if (players_games.has(player_id)):
		if players_states.has(player_id):
			if players_states[player_id]["T"] < player_state["T"]:
				players_states[player_id] = player_state
		else:
			players_states[player_id] = player_state
			
remote func ReceiveShootAction(shoot_action):
	var player_id = get_tree().get_rpc_sender_id()
	if (players_games.has(player_id)):
		var gameId = players_games.get(player_id)
		for player in get_node(gameId).players:
			if player != player_id:
				rpc_id(player, "ReceiveShootAction", shoot_action, player_id)
	
remote func ReceiveDeathCall(death):
	var player_id = get_tree().get_rpc_sender_id()
	if (players_games.has(player_id)):
		var gameId = players_games.get(player_id)
		for player in get_node(gameId).players:
			if player != player_id:
				rpc_id(player, "ReceiveShootAction", death, player_id)
				
remote func ReceiveRespawn(respawn_action):
	var player_id = get_tree().get_rpc_sender_id()
	if (players_games.has(player_id)):
		var gameId = players_games.get(player_id)
		for player in get_node(gameId).players:
			if player != player_id:
				rpc_id(player, "ReceiveRespawn", respawn_action, player_id)
				
remote func ReceiveDeath(death_action):
	var player_id = get_tree().get_rpc_sender_id()
	if (players_games.has(player_id)):
		var gameId = players_games.get(player_id)
		for player in get_node(gameId).players:
			if player != player_id:
				rpc_id(player, "ReceiveDeath", death_action, player_id)

func SetQueueStatus(player_id, status):
	rpc_id(player_id, "SetQueueStatus", status)

		
func SendWorldState(players, world_state):
	for player in players:
		rpc_unreliable_id(player, "RecieveWorldState", world_state)

func SpawnNewPlayers(player_id, players, positions):
	rpc_id(player_id, "SpawnNewPlayers", players, positions)
	
func DespawnPlayer(player_id, player):
	rpc_id(player_id, "DespawnPlayer", player)

remote func JoinQueue():
	var player_id = get_tree().get_rpc_sender_id()
	if !get_node("Queue").IsInQueue(player_id):
		get_node("Queue").AddPlayer(player_id)
	SetQueueStatus(player_id, 1)
