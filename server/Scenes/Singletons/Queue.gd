extends Node

const PLAYERS_PER_GAME = 1

var GAME_PATH = preload("res://Scenes/Instances/Game.tscn")
var queue = []


func GenerateGameId():
	var gameName = "Game_" + str(randi() % 10000)
	while get_parent().has_node(gameName):
		gameName = "Game_" + str(randi() % 10000)
	return gameName

func CreateGame():
	var game = GAME_PATH.instance()
	game.name = GenerateGameId()
	get_parent().add_child(game, true)
	for i in (PLAYERS_PER_GAME):
		var player = queue.pop_front()
		game.AddPlayer(player)

func AddPlayer(player_id):
	queue.append(player_id)
	if len(queue) >= PLAYERS_PER_GAME:
		CreateGame()
	print("Added Player")

func RemoveFromQueue(player_id):
	queue.remove(queue.find(player_id))
	
func IsInQueue(player_id) -> bool:
	if queue.find(player_id) == -1:
		return false
	else: 
		return true
