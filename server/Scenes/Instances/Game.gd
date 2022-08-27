extends Node2D


var PLAYER = preload("res://Scenes/Instances/Player.tscn")
var players = []
var game_status = 0
var world_state = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	var SERVER = get_parent()  # Replace with function body.

func _physics_process(delta):
	if game_status == 1:
		world_state.clear()
		world_state["Players"] = {}
		for player in players:
			if get_parent().players_states.has(player):
				world_state['Players'][player] = get_parent().players_states[player].duplicate(true)
				world_state['Players'][player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		get_parent().SendWorldState(players, world_state)

func AddPlayer(player):
	var player_cont = PLAYER.instance()
	player_cont.name = str(player)
	get_parent().players_games[player] = self.name 
	add_child(player_cont, true)
	players.append(player)
	
func RemovePlayer(player):
	if players.has(player):
		players.remove(players.find(player))
		#get_node(player).queue_free()
		for player_id in players:
			get_parent().DespawnPlayer(player_id, player)
	if len(players) == 0:
		game_status = 0
		queue_free()
	
func StartGame():
	game_status = 1
	var positions = []
	for player in players:
		positions.append(Vector2((-1000 + randi() % 600), (randi() % 400)))
	for player in players:
		get_parent().SpawnNewPlayers(player, players, [Vector2(0,500), Vector2(100,500)])
